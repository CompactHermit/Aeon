{ flake, modulesPath, lib, pkgs,config, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    #flake.inputs.disko.nixosModules.disko ## Currenly testing this. When I can just copy over the config, then I'll try
    #./disko/one-nvme-luks.nix
  ] ++
  (with flake.inputs.nixos-hardware.nixosModules; [
    # Framework Specific Stuff. Wait for PR upstream (#765) to just import the 7040 module
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop
    common-pc-laptop-ssd
  ]);


  environment.variables.EDITOR = "nvim";
  system.stateVersion = "23.11";

  services = {
    fprintd.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;
  };

  boot = {
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "dm-snapshot" "tpm_crb" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
      #NOTE:: Does disko even handle this? Will check the interface upstream
      kernelModules = ["amdgpu"];
      luks.devices = {
        luksroot = {
          device = "/dev/disk/by-uuid/7abaafc1-d276-437d-8963-fc4da67458d8";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  services.fwupd.enable = true;
  # hardware.cpu.intel.updateMicrocode = true;
  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.enableRedistributableFirmware;

  };

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkForce true; #(Hermit) I, what, why, for what reason????
    wireless.enable = false;
    firewall = {
      allowedTCPPorts = [443 80 22 631];
      allowedUDPPorts = [443 80 22 631];
      enable = false;
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    usePredictableInterfaceNames = false;
  };

  systemd = {
    services.NetworkManager-wait-online.enable = lib.mkForce false;
    services.update-prefetch.enable = false;
    services.sshd.wantedBy = lib.mkForce ["multi-user.target"];
  };

  services.resolved.enable = true;


  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  networking.hostName = "CompactHermit";
}
