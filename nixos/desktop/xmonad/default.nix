{ config, pkgs, inputs, ... }:
let myXmonadProject = ./Machinex;
in {
  environment.systemPackages = with pkgs;
    [ xorg.xdpyinfo xorg.xrandr arandr autorandr dzen2 brave ]
    ++ (with pkgs.haskellPackages; [
      notifications-tray-icon
      gtk-sni-tray
      gnome.adwaita-icon-theme
      status-notifier-item
      dbus-hslogger
    ]);

  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "amdgpu" ];
    displayManager.defaultSession = "none+xmonad";
    windowManager.xmonad = {
      enable = true;
      haskellPackages = pkgs.haskellPackages.extend
        (import "${myXmonadProject}/overlay.nix" { inherit pkgs; });
      extraPackages = hp: [ hp.xmonad-contrib hp.xmonad-extras hp.xmonad-dbus ];
      config = pkgs.lib.readFile "${myXmonadProject}/xmonad.hs";
    };
  };
}
