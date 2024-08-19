{
  flake,
  modulesPath,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports =
    [
      self.nixosModules.xmonad
      self.nixosModules.system
      (modulesPath + "/installer/scan/not-detected.nix")
      flake.inputs.disko.nixosModules.disko
      flake.inputs.fw-fanctrl.nixosModules.default
      ./disks.nix
    ]
    ++ (with flake.inputs.nixos-hardware.nixosModules; [
      # Framework Specific Stuff. Wait for PR upstream (#765) to just import the 7040 module
      framework-13-7040-amd
    ]);

  environment.variables.EDITOR = "nvim";
  system.stateVersion = "23.05";

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  services = {
    fwupd.enable = true;
    fprintd = {
      enable = lib.mkForce false;
      package = pkgs.fprintd.overrideAttrs (_: {
        mesonCheckFlags = [
          "--no-suite"
          "fprintd:TestPamFprintd"
        ];
      });
    };
    openssh.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs.fw-fanctrl.enable = true;

  # Add a custom config
  programs.fw-fanctrl.config = {
    defaultStrategy = "lazy";
    strategies = {
      "lazy" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        speedCurve = [
          {
            temp = 0;
            speed = 15;
          }
          {
            temp = 50;
            speed = 15;
          }
          {
            temp = 65;
            speed = 25;
          }
          {
            temp = 70;
            speed = 35;
          }
          {
            temp = 75;
            speed = 50;
          }
          {
            temp = 85;
            speed = 100;
          }
        ];
      };
    };
  };

  boot = {
    tmp.cleanOnBoot = true;
    loader.grub = {
      enable = true;
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [
      "amd_iommu=on"
      "video=eDP-1:2256x1504@60"
      "video=DP-2:1920x1080@60"
      "video=DP-4:1920x1080@60"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "dm-snapshot"
      "tpm_crb"
      "kvm-amd"
    ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "amdgpu" ];
    };
  };

  nix.monitored = {
    notify = false;
    enable = true;
  };
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  # hardware.cpu.intel.updateMicrocode = true;
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    framework.amd-7040.preventWakeOnAC = true;
    # https://github.com/NixOS/nixos-hardware/issues/1330
    # disable framework kernel module
    # framework.enableKmod = false;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    networkmanager = {
      wifi.scanRandMacAddress = false;
      enable = true;
    };
    useDHCP = lib.mkForce true; # (Hermit) I, what, why, for what reason????
    wireless.enable = false;
    firewall = {
      allowedTCPPorts = [
        443
        80
        8448
        22000
      ];
      allowedUDPPorts = [
        443
        80
        21027
      ];
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
    services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 150;
    algorithm = "zstd";
  };

  services.resolved = {
    enable = false;
  };
  services.blueman.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  networking.hostName = "CompactHermit";
  networking.domain = "compacthermit.dev";
}
