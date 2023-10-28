{pkgs,...}:{
  # TODO:: (CH) <10/25> Somehow incorporate an option system
  imports = [
    #./polybar
    ./xmonad
    ./hidpi.nix
    ./terminal.nix
    ./fonts.nix
    ./gnome-keyring.nix ## Probably remove this
  ];

  environment.systemPackages = with pkgs; [
    acpi
    imv

    kitty
    alacritty

    xorg.xmessage
    tor-browser-bundle-bin
    gimp
    inkscape
    mupdf

    # Messaging
    vencord
    element-desktop
    signal-desktop
    tdesktop
    iamb

    # Basic Utilities

    # Torrent / P2P
    qbittorrent
    transmission-gtk
    librsvg

    # video pkgs
    vlc
    dmenu
    untrunc
    obs-studio
    ffmpeg-full
  ];

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
  };

  #XDG_Configs Here::
  xdg = {
    portal.enable = true;
  };

  # NOTE:: (Hermit) Speeds up Boot
  # https://discourse.nixos.org/t/boot-faster-by-disabling-udev-settle-and-nm-wait-online/6339
  systemd.services = {
    systemd-udev-settle.enable = false;
    NetworkManager-wait-online.enable = false;
  };

}
