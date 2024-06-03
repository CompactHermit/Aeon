{ flake, pkgs, ... }: {
  programs.yazi = {
    enable = true;
    package = flake.inputs.yazi.packages."x86_64-linux".yazi;
  };
  # home.file.".config/yazi/theme.toml" = { source = ./theme.toml; };
  home.file.".config/yazi/yazi.toml" = { source = ./yazi.toml; };
  # home.file.".config/yazi/keymap.toml" = { source = ./keymap.toml; };
  home.file.".config/yazi/plugins/bypass.yazi/init.lua" = {
    source = ./bypass.lua;
  };
  home.file.".config/yazi/plugins/starship.yazi/init.lua" = {
    source = ./starship.lua;
  };
  home.file.".config/yazi/plugins/hexyl.yazi/init.lua" = {
    source = ./hexyl.lua;
  };
  home.file.".config/yazi/plugins/glow.yazi/init.lua" = {
    source = ./glow.lua;
  };
}
