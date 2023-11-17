{ flake, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        monospace = [
          "VictorMono Nerd Font"
          "Iosevka Term"
          "Iosevka Term Nerd Font Complete Mono"
          "Iosevka Nerd Font"
          "Noto Color Emoji"
        ];

        sansSerif = [
          "Lexend"
          "Noto Color Emoji"
          "VictorMono Nerd Font" 
        ];

        serif = [
          "Noto Serif"
          "Noto Color Emoji"
        ];

        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
    # TODO:: Use ICOMOON to add custom Fonts for Kitty's fallback feature
    packages = (with pkgs; [
      corefonts
      material-design-icons
      roboto
      work-sans
      source-sans
      twemoji-color-font
      comfortaa
      inter
      lato
      jost
      lexend
      dejavu_fonts
      iosevka-bin
      noto-fonts
      noto-fonts-cjk
      noto-fonts-color-emoji
      emacs-all-the-icons-fonts
      julia-mono
      noto-fonts-emoji
      material-icons
      victor-mono
      fira-code
      ubuntu_font_family
      cascadia-code
      nerdfonts
      ico-patched
    ]);
  };
}
