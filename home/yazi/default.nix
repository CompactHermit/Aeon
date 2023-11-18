{
  flake,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    package = flake.inputs.yazi.packages."x86_64-linux".yazi;
  };
  home.file.".config/yazi/theme.toml" = {
    source = ./theme.toml;
  };
}
