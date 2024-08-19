{
  pkgs,
  config,
  ...
}:
{

  niri-flake.cache.enable = true;
  services.xserver = {
    # Enable the X11 windowing system
    enable = true;
    videoDrivers = [ "amdgpu" ];

    # Configure keymap in X11

    # Enable the GNOME Desktop Environment
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Disable XTerm
    desktopManager.xterm.enable = false;
  };

  # Exclude certain packages from GNOME
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour # GNOME guide
    epiphany # web browser
    geary # email reader
  ];
  # Niri, scrollable-tiling Wayland compositor
  programs.niri = {
    enable = true;
    # package = pkgs.niri-unstable;
  };
  # programs.hyprlock.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      acpi
      imv

      kitty

      inkscape
      mupdf

      # Torrent / P2P
      qbittorrent
      transmission_4-gtk

      # video pkgs
      mpv
      ffmpeg
      # --- Niri
      xwayland-satellite # Xwayland
      hypridle # Idle daemon
      waybar # Statusbar
      wlr-which-key
      fuzzel
      mpvpaper # Animated wallpapers from MP4
      rofi-wayland # App launcher
      playerctl # Control audio
      swaybg # Wallpaper
      swaynotificationcenter # Notification daemon and center
      wlogout # Logout menu
      swayosd # GNOME-like OSD
      ;
  };

  # Enable gnome-settings-daemon udev rules to make sure tray works well
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # Automatically login to GNOME session
  services.displayManager = {
    defaultSession = "niri";
    # autoLogin.user = "Wyze";
  };

  # Make Electron applications use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
