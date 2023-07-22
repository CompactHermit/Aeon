{ config, lib, pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fontconfig.defaultFonts = {
      monospace = [ "VictorMono Nerd Font" ];
      sansSerif = [ "VictorMono Nerd Font" ];
    };
    fonts = with pkgs; [
      # NOTE: Some fonts may break colour emojis in Chrome
      # cf. https://github.com/NixOS/nixpkgs/issues/69073#issuecomment-621982371
      # If this happens , keep noto-fonts-emoji and try disabling others (nerdfonts, etc.)
      noto-fonts-emoji
      victor-mono
      fira-code
      cascadia-code
      nerdfonts
      powerline-fonts
      b612
    ];
  };
}
