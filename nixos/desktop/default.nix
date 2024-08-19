{ pkgs, flake, ... }:
{
  # TODO:: (CH) <10/25> Somehow incorporate an option system
  imports = [
    ./xmonad
    ./hidpi.nix
    ./terminal.nix
    ./fonts.nix
    ./gnome-keyring.nix
    ./gaming.nix
  ];

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      acpi
      imv

      kitty
      # alacritty

      inkscape
      mupdf

      # Messaging
      vencord
      # element-desktop
      # signal-desktop
      # tdesktop
      #iamb

      # Torrent / P2P
      qbittorrent
      transmission_4-gtk

      # video pkgs
      mpv
      ffmpeg
      ;
    inherit (flake.inputs.ghostty.packages."x86_64-linux") ghostty;
  };

  hardware = {
    opengl.enable = true;
  };

  #XDG_Configs Here::
  xdg = {
    portal.enable = true;
  };

  programs.dconf.enable = true;
  # NOTE:: (Hermit) Speeds up Boot
  # https://discourse.nixos.org/t/boot-faster-by-disabling-udev-settle-and-nm-wait-online/6339
  systemd.services = {
    systemd-udev-settle.enable = false;
    NetworkManager-wait-online.enable = false;
  };
}
