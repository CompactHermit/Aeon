{ pkgs, ... }: {
  # https://unix.stackexchange.com/a/434752
  services.gnome.gnome-keyring.enable = true;
}
