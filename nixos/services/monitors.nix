{ pkgs, ... }:
{
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --output DP-4 --above eDP-1 --output DP-2 --right-of eDP-1
  '';

  # setupCommands = ''
  #         autorandr -c
  #         systemctl restart autorandr.service
  #       '';
  #     };
  #   };
  #
  #   services.autorandr = {
  #     enable = true;
  #   };
}
