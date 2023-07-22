{pkgs,...}:{
  # TODO:: (CH) <10/25> Somehow incorporate an option system
  imports = [
    ./xmonad
    ./hidpi.nix
    ./terminal.nix
    ./fonts.nix
    # ./touchpad-trackpoint.nix
    ./gnome-keyring.nix ## Probably remove this
  ];

  environment.systemPackages = with pkgs; [
    acpi
    imv
    #xorg.xmessage
    tor-browser-bundle-bin
    nyxt


    gimp
    inkscape
    mupdf

    # IM
    vencord
    element-desktop
    signal-desktop
    tdesktop
    iamb


    # Torrent / P2P
    qbittorrent
    transmission-gtk
    librsvg


    # video pkgs
    vlc
    untrunc
    obs-studio
    ffmpeg-full

  ];

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
  };
  hardware.pulseaudio.enable = false;

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
