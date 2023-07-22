{ flake, modulesPath, lib, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.disko.nixosModules.disko
  ];
  system.stateVersion = "22.11";
  services.openssh.enable = true;
  boot.loader.grub = {
    devices = [ "/dev/nvme0n1" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "sd_mod" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; # For cross-compiling, https://discourse.nixos.org/t/how-do-i-cross-compile-a-flake/12062/4?u=srid
  nixpkgs.hostPlatform = "x86_64-linux";


  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "CompactHermit";
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" ];
  disko.devices = import ./disko/one-nvme-luks.nix {
    inherit lib flake;
  };
}
