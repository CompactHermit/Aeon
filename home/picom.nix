{pkgs,...}:{
  services.picom = {
    enable = true;
    package = pkgs.picom-allusive;
  };
  xdg.configFile."picom.conf" = {
    source = ./picom.conf;
  };
}
