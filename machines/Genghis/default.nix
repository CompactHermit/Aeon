{ flake, modulesPath, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.disko.nixosModules.disko
    ./disko/one-nvme-luks.nix] ++
    (with flake.inputs.nixos-hardware.nixosModules;[
    # Framework Specific Stuff. Wait for PR upstream (#765) to just import the 7040 module
    common-cpu-amd
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop
    common-pc-laptop-ssd
  ]);
  system.stateVersion = "22.11";
  services = {
    fprintd.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      devices = [ "/dev/nvme0n1" ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "sd_mod" ];
    binfmt.emulatedSystems = [ "aarch64-linux" ];
};
  nixpkgs.hostPlatform = "x86_64-linux";

  # hardware.cpu.intel.updateMicrocode = true;
  hardware = {
    enableRedistributableFirmware = true;
  };

  networking.hostName = "CompactHermit";
  networking.useDHCP = false;
  networking.nameservers = [ "8.8.8.8" ];
  
}
