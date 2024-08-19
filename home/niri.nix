{ config, ... }:
{

  stylix.targets.niri.enable = true;

  # https://github.com/sodiboo/niri-flake/blob/main/docs.mdprogramsnirisettings
  programs.niri = {
    enable = true;
    settings = {
      # hotkey-overlay.skip-at-startup = true;

      # causes a deprecation warning otherwise
      layout = {
        center-focused-column = "always";
      };
      # outputs = {
      #   "eDP-1" = {
      #     transform.rotation = 270;
      #   };
      # };
      #Window-Rule
      #Workspaces
      # workspaces = {
      #   "term" = { };
      #   "browser" = { };
      #   "spotify" = { };
      #   "Library" = { };
      #   "LMStudio" = { };
      # };

      # spawn-at-startup = [
      #   "kitty"
      # ];
      # input = {
      #   mouse = {
      #     accel-profile = "adaptive";
      #   };
      #   touchpad = {
      #     enable = true;
      #     tap = true;
      #     dwt = true; # Disable While Typing
      #     dwtp = true; # Disable During Touchpad
      #     disabled-on-external-mouse = true;
      #     drag-lock = true;
      #     scroll-method = "two-finger";
      #
      #   };
      # };
      # binds =
      #   let
      #     inherit (config.lib.niri.action)
      #       set-column-width
      #       quit
      #       spawn
      #       focus-workspace
      #       power-off-monitors
      #       toggle-debug-tint
      #       focus-window-previous
      #       focus-column-right-or-first
      #       focus-column-left-or-last
      #       move-window-to-workspace
      #       swap-window-left
      #       swap-window-right
      #       toggle-column-tabbed-display
      #       toggle-overview
      #       move-window-to-monitor
      #       consume-window-into-column
      #       expel-window-from-column
      #       ;
      #   in
      #   {

      #Workspace Switch
      # "Mod+1".action = focus-workspace "term";
      # "Mod+2".action = focus-workspace "browser";
      # "Mod+3".action = focus-workspace "spotify";
      # "Mod+4".action = focus-workspace "Library";
      # "Mod+5".action = focus-workspace "LMStudio";
      # "Mod+6".action = focus-workspace 6;
      # "Mod+7".action = focus-workspace 7;

      # #Workspace Push
      # "Mod+Shift+1".action = move-window-to-workspace 1;
      # "Mod+Shift+2".action = move-window-to-workspace 2;
      # "Mod+Shift+3".action = move-window-to-workspace 3;
      # "Mod+Shift+4".action = move-window-to-workspace 4;
      # "Mod+Shift+5".action = move-window-to-workspace 5;
      # "Mod+Shift+6".action = move-window-to-workspace 6;
      # "Mod+Shift+7".action = move-window-to-workspace 7;
      # "Mod+Shift+8".action = move-window-to-workspace 8;

      #         #Movement
      #         "Mod+n".action = focus-window-previous;
      #         "Mod+j".action = focus-column-left-or-last;
      #         "Mod+k".action = focus-column-right-or-first;
      #
      #         #Swaps
      #         "Mod+Shift+h".action = swap-window-left;
      #         "Mod+Shift+l".action = swap-window-right;
      #
      #         #Layouts::
      #         "Mod+Shift+t".action = toggle-column-tabbed-display;
      #
      #         #Spawns
      #         "Mod+D".action = spawn "fuzzel";
      #         "Mod+S".action = toggle-overview;
      #         "Mod+e".action = spawn "kitty";
      #         "Mod+Ctrl+Shift+E".action = quit { skip-confirmation = true; };
      #
      #         #Resize
      #         "Mod+Plus".action = set-column-width "+15%";
      #         "Mod+Minus".action = set-column-width "-15%";
      #
      #         #Toggles/Power
      #         "Mod+Shift+P".action = power-off-monitors;
      #         "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
      #         #Volume
      #         "XF86AudioRaiseVolume".action = spawn [
      #           "wpctl"
      #           "set-volume"
      #           "@DEFAULT_AUDIO_SINK@"
      #           "0.1+"
      #         ];
      #         "XF86AudioLowerVolume".action = spawn [
      #           "wpctl"
      #           "set-volume"
      #           "@DEFAULT_AUDIO_SINK@"
      #           "0.1-"
      #         ];
      #       };
      #     window-rules = [
      #       {
      #         open-maximized = true;
      #         draw-border-with-background = false;
      #         clip-to-geometry = true;
      #         geometry-corner-radius = {
      #           top-left = 8.0;
      #           top-right = 8.0;
      #           bottom-left = 8.0;
      #           bottom-right = 8.0;
      #         };
      #       }
      #     ];
    };
  };
}
