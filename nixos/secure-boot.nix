{ lib, pkgs, ... }: {
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
  };

  hardware.enableAllFirmware = true;
  boot.supportedFilesystems = [ "btrfs" "ntfs" ];

  # Quiet boot with plymouth - supports LUKS passphrase entry if needed
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.plymouth.enable = false;

  # Bootspec and Secure Boot using lanzaboote
  #
  # See: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  #
  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # TPM for unlocking LUKS
  #
  # TPM kernel module must be enabled for initrd. Device driver is viewable via the command:
  # sudo systemd-cryptenroll --tpm2-device=list
  # And added to a device's configuration:
  # boot.initrd.kernelModules = [ "tpm_tis" ];
  #
  # Must be enabled by hand - e.g.
  # sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/nvme0n1p3 --tpm2-device=auto --tpm2-pcrs=0+2+7
  #
  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
}
