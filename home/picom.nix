{ flake, pkgs, ... }:
{
  services.picom = {
    enable = true;
    package =
      let
        picom' = flake.inputs.picom.defaultPackage."x86_64-linux";
      in
      pkgs.symlinkJoin {
        name = "picom";
        paths = [
          (pkgs.writeShellScriptBin "picom" (
            let
              grayscale-glsl = pkgs.writeText "grayscale.glsl" ''
                #version 330

                in vec2 texcoord;
                uniform sampler2D tex;
                uniform float opacity;

                vec4 default_post_processing(vec4 c);

                vec4 window_shader() {
                  vec2 texsize = textureSize(tex, 0);
                  vec4 color = texture2D(tex, texcoord / texsize, 0);

                  color = vec4(vec3(0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b) * opacity, color.a * opacity);

                  return default_post_processing(color);
                }
              '';
            in
            ''
              if [ "$PICOM_SHADER" = "grayscale" ]; then
                "${picom'}/bin/picom" \
                  --window-shader-fg="${grayscale-glsl}" \
                  "$@"
              else
                "${picom'}/bin/picom" "$@"
              fi
            ''
          ))
          picom'
        ];
      }
      // {
        inherit (picom') meta;
      };
    backend = "glx";
    fade = true;
    fadeDelta = 3;
    inactiveOpacity = 0.95;
    menuOpacity = 0.95;
    shadow = true;
    shadowOffsets = [
      (-7)
      (-7)
    ];
    shadowExclude = [
      # unknown windows
      "! name~=''"
      # shaped windows
      "bounding_shaped && !rounded_corners"
      # no shadow on i3 frames
      "class_g = 'i3-frame'"
      # hidden windows
      "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      # stacked / tabbed windows
      "_NET_WM_STATE@[0]:a = '_NET_WM_STATE@_MAXIMIZED_VERT'"
      "_NET_WM_STATE@[0]:a = '_NET_WM_STATE@_MAXIMIZED_HORZ'"
      # GTK
      "_GTK_FRAME_EXTENTS@:c"
      "class_g ~= 'xdg-desktop-portal' && _NET_FRAME_EXTENTS@:c && window_type = 'dialog'"
      "class_g ~= 'xdg-desktop-portal' && window_type = 'menu'"
      "_NET_FRAME_EXTENTS@:c && WM_WINDOW_ROLE@:s = 'Popup'"
      # Mozilla fixes
      "(class_g *?= 'firefox' || class_g = 'thunderbird') && (window_type = 'utility' || window_type = 'popup_menu') && argb"
      # notifications
      "_NET_WM_WINDOW_TYPE@:32a *= '_NET_WM_WINDOW_TYPE_NOTIFICATION'"
      # Zoom
      "name = 'cpt_frame_xcb_window'"
      "class_g *?= 'zoom' && name *?= 'meeting'"
    ];
    opacityRules =
      # Only apply these opacity rules if the windows are not hidden
      map (str: str + " && !(_NET_WM_STATE@[*]:a *= '_NET_WM_STATE_HIDDEN')") [
        "100:class_g *?= 'zoom' && name *?= 'meeting'"
        "100:role = 'browser' && name ^= 'Meet -'"
        "100:role = 'browser' && name ^= 'Netflix'"
        "95:class_g = 'Emacs'"
      ]
      ++ [
        "0:_NET_WM_STATE@[*]:a *= '_NET_WM_STATE_HIDDEN'"
        "100:name     = 'Dunst'"
        "80:class_g    = 'eww-blur_full'"
        "60:class_g    = 'eww-player'"
        "60:class_g    = 'eww-bar'"
        "90:class_g    = 'Zotero'"
        "100:class_g    = 'Tint2'"
        "10:class_g = 'Conky' "
        "50:class_g     = 'Polybar'"
        "85:class_g    = 'Alacritty'"
        "100:class_g    = 'Inkscape'"
        "100:class_g    = 'kitty'"
        "85:class_g    = 'org.wezfurlong.wezterm'"
        "90:class_g    = 'zen-twilight'"
        "90:class_g    = 'zen'"
        "95:class_g    = 'firefox-nightly'"

      ];
    vSync = true;
    settings = {
      animations = true;
      # With a higher stiffness the windows go to the final animation position
      # faster resulting in a snappier looking transition. (0 - 500, defaults
      # to 120)
      animation-stiffness = 120;
      # The higher value, the more windows are dampened, the slower/softer
      # they come into and out of view. (0 - 50, defaults to 12)
      animation-dampening = 12;
      # Increases the windows virtual weight (> 0.0, defaults to 0.5)
      animation-window-mass = 0.5;
      animation-clamping = true;
      # Set the open window animation
      # (none/zoom/slide-up/slide-down/slide-left/slide-right/fly-in, defaults
      # to zoom)
      animation-for-open-window = "slide-left";
      # (none/zoom/slide-up/slide-down/slide-left/slide-right/fly-in, defaults
      # to zoom)
      animation-for-unmap-window = "zoom";
      # Exclude conditions for open-window animations
      animation-open-exclude = [ ];
      # Exclude conditions for unmap-window animations
      animation-unmap-exclude = [ ];
      inactive-dim = 0.2;
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
      corner-radius = 20;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
      blur-background-exclude = [
        # shaped windows
        "bounding_shaped && !rounded_corners"
        # hidden windows
        "_NET_WM_STATE@[*]:a *= '_NET_WM_STATE_HIDDEN'"
        # stacked / tabbed windows
        "_NET_WM_STATE@[0]:a = '_NET_WM_STATE@_MAXIMIZED_VERT'"
        "_NET_WM_STATE@[0]:a = '_NET_WM_STATE@_MAXIMIZED_HORZ'"
        # i3 borders
        "class_g = 'i3-frame'"
        # GTK
        "_GTK_FRAME_EXTENTS@:c"
        "class_g ~= 'xdg-desktop-portal' && _NET_FRAME_EXTENTS@:c && window_type = 'dialog'"
        "class_g ~= 'xdg-desktop-portal' && window_type = 'menu'"
        "_NET_FRAME_EXTENTS@:c && WM_WINDOW_ROLE@:s = 'Popup'"
        # Mozilla fixes
        "(class_g *?= 'firefox'||class_g *?= 'zen' || class_g = 'thunderbird') && (window_type = 'utility' || window_type = 'popup_menu') && argb"
        # Zoom
        "name = 'cpt_frame_xcb_window'"
        "class_g *?= 'zoom' && name *?= 'meeting'"
        "class_g = 'Peek'"
      ];
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      detect-client-opacity = true;
      detect-transient = true;
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      use-damage = true;
      shadow-radius = 7;
      xinerama-shadow-crop = true;
      xrender-sync-fence = true;
      focus-exclude = [
        "name = 'Picture-in-Picture'"
        "_NET_WM_STATE@[*]:a *= '_NET_WM_STATE_FULLSCREEN'"
        "class_g *?= 'zoom' && name *?= 'meeting'"
      ];
      detect-rounded-corners = true;
      win-types = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.8;
          focus = true;
          full-shadow = false;
        };
        dock = {
          shadow = false;
          clip-shadow-above = true;
        };
        dnd = {
          shadow = false;
        };
        popup_menu = {
          opacity = 0.9;
        };
        dropdown_menu = {
          opacity = 0.9;
        };
      };
    };
  };
}
