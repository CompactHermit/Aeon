{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")];

  #boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  #boot.initrd.kernelModules = [ "dm-snapshot" ];
  #boot.kernelModules = [ "kvm-amd" ];
  #boot.extraModulePackages = [ ];
  boot.kernelParams = [
    "video=eDP-1:2256x1504@60"
    "video=DP-2:1920x1080@60"
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d6fb1715-72d6-493e-8f33-d40d45f6f8cb";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime"];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/d6fb1715-72d6-493e-8f33-d40d45f6f8cb";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime"];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/d6fb1715-72d6-493e-8f33-d40d45f6f8cb";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime"];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/d6fb1715-72d6-493e-8f33-d40d45f6f8cb";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime"];
    };

  fileSystems."/state" =
    { device = "/dev/disk/by-uuid/d6fb1715-72d6-493e-8f33-d40d45f6f8cb";
      fsType = "btrfs";
      options = [ "subvol=state" "compress=zstd" "noatime"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C240-10B3";
      fsType = "vfat";
    };


   # TODO:: Custom Library
  fileSystems."/home/CompactHermit/Library" =
    { device = "/dev/disk/by-uuid/6474-DBFC";
      fsType = "exfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ed3b8b14-e11d-48ca-a8bf-cc71e8ce5639"; }
    ];

    #networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.amd.updateMicrocode = true;
}
