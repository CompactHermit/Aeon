{ config, lib, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      monospace = [ "VictorMono Nerd Font" ];
      sansSerif = [ "VictorMono Nerd Font" ];
    };
    # TODO:: Use ICOMOON to add custom Fonts for Kitty's fallback feature
    packages = with pkgs; [
      julia-mono
      noto-fonts-emoji
      material-icons
      victor-mono
      fira-code
      ubuntu_font_family
      cascadia-code
      nerdfonts
      b612
    ];
  };
}
