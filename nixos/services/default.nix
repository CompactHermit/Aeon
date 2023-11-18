{pkgs, ...}: {
  imports = [
    #./hydra.nix
    ./kmonad.nix
    ./monitors.nix
    ./syncthing.nix
    ./attic.nix
  ];
  services = {
    dbus.enable = true;
    flatpak.enable = true;
    tor.enable = true;
    tor.client.enable = true;
    printing.enable = true;
    printing.drivers = [pkgs.hplip];
    greenclip.enable = true;
    udisks2.enable = true;
  };

  programs.firejail.enable = true;
  programs.mtr.enable = true;
  programs.extra-container.enable = true;
  #programs.sysdig.enable = true;
}
