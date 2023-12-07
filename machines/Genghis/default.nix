{
  flake,
  modulesPath,
  lib,
  pkgs,
  config,
  ...
}: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      flake.inputs.disko.nixosModules.disko
      ./disks.nix
    ]
    ++ (with flake.inputs.nixos-hardware.nixosModules; [
      # Framework Specific Stuff. Wait for PR upstream (#765) to just import the 7040 module
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-laptop
      common-pc-laptop-ssd
    ]);

  environment.variables.EDITOR = "nvim";
  system.stateVersion = "23.05";

  services = {
    fwupd.enable = true;
    fprintd.enable = true;
    openssh.enable = true;
    #power-profiles-daemon.enable = true;
  };

  boot = {
    tmp.cleanOnBoot = true;
    loader.grub = {
      enable = true;
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [
      "video=eDP-1:2256x1504@60"
      "video=DP-2:1920x1080@60"
      "video=DP-4:1920x1080@60"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["dm-snapshot" "tpm_crb" "kvm-amd"];
    initrd = {
      availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
  };

  nixpkgs = {
    #config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  # hardware.cpu.intel.updateMicrocode = true;
  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    networkmanager = {
      wifi.scanRandMacAddress = false;
      enable = true;
    };
    useDHCP = lib.mkForce true; #(Hermit) I, what, why, for what reason????
    wireless.enable = false;
    firewall = {
      allowedTCPPorts = [443 80 8448 2222];
      allowedUDPPorts = [443 80];
      enable = true;
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      #"8.8.8.8"
      #"8.8.4.4"
    ];
    usePredictableInterfaceNames = false;
  };

  systemd = {
    services.NetworkManager-wait-online.enable = lib.mkForce false;
    services.update-prefetch.enable = false;
    services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
  };

  services.resolved = {
    enable = false;
    # dnssec = "true";
    # domains = [ "compacthermit.dev" ];
    # fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    # extraConfig = ''
    # DNSOverTLS=yes
    # '';
  };
  security.sudo.wheelNeedsPassword = false;
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  networking.hostName = "CompactHermit";
  networking.domain = "compacthermit.dev";
}
