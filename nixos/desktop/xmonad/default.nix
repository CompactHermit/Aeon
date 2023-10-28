{ config, pkgs, ... }:
let
  myXmonadProject = ./Machinex;
in
  {
    environment.systemPackages = with pkgs; [
      xorg.xdpyinfo
      xorg.xrandr
      arandr
      autorandr

      dzen2
    ];

    services.xserver = {
      enable = true;
      layout = "us";
      windowManager.xmonad = {
        enable = true;
        haskellPackages = pkgs.haskellPackages.extend (import "${myXmonadProject}/overlay.nix" { inherit pkgs; });
        extraPackages = hp: with pkgs.haskell.lib; [
          hp.xmonad-contrib
          hp.xmonad-extras
          hp.xmonad-dbus
        ];
      # enableContribAndExtras = true;  -- using our own
      config = pkgs.lib.readFile "${myXmonadProject}/xmonad.hs";
    };
  };
  services.xserver.displayManager.defaultSession = "none+xmonad";
}
