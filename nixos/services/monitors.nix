{pkgs, ...}: {
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --output DP-2 --right-of eDP-1
  '';
}
