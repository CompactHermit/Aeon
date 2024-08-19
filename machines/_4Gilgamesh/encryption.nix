{
  pkgs,
  config,
  device,
  swapsize,
  ...
}:
{

  # my.sway-auto-lock.enable = true;

  services = {
    btrfs.autoScrub.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      autoLogin = {
        enable = true;
        user = "wyze";
      };
    };

    btrbk.instances.btrbk = {
      onCalendar = "hourly";
      settings = {
        snapshot_create = "always";
        snapshot_dir = "/.snapshots";
        snapshot_preserve_min = "latest";
        snapshot_preserve = "24h";
        volume."/".subvolume = {
          "/" = { };
          "home" = { };
        };
      };
    };
  };

  # instance.snapshotOnly added in 25.05
  systemd.services.btrbk-btrbk.serviceConfig.ExecStart =
    pkgs.lib.mkForce "${pkgs.btrbk}/bin/btrbk -c /etc/btrbk/btrbk.conf snapshot";

}
