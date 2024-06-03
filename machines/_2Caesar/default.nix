{ lib, pkgs, config, ... }:
let
  inherit (builtins) attrValues;
  inherit (lib) mkIf mkForce;
in {

  /* *
     TODO: Hermit::
     1.Properly package userSpace Kernel-drivers ->> Add on extra Layouts
  */
  imports = [ ./configuration.nix ./ppkb.nix ./hardware-configuration.nix ];

  mobile.quirks.supportsStage-0 = mkForce false;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 150;

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "my-rewrite-boot-partition" ''
      echocmd() {
        echo "$@"
        "$@"
      }
      echocmd sudo dd if=${config.mobile.outputs.u-boot.boot-partition} of=/dev/mmcblk2p1 bs=8M oflag=direct,sync status=progress
    '')
  ];
}
