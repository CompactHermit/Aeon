{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty.conf;
    #package = pkgs.kitty-nightly;
  };
  stylix.targets.kitty.enable = true;
}
