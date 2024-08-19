{ pkgs, lib, ... }:
{
  fonts = {
    #enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        monospace = [
          "CommitMono Nerd Font"
          "VictorMono Nerd Font"
          "Iosevka Term"
          "Julia-mono"
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

        emoji = [ "Noto Color Emoji" ];
      };
    };
    # TODO:: Use ICOMOON to add custom Fonts for Kitty's fallback feature
    packages =
      builtins.attrValues {
        inherit (pkgs)
          corefonts
          material-design-icons
          sarasa-gothic
          commit-mono
          lexend
          dejavu_fonts
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          julia-mono
          noto-fonts-emoji
          material-icons
          victor-mono
          fira-code
          ubuntu_font_family
          cascadia-code
          ico-patched
          ;
      }
      ++ builtins.filter (lib.attrsets.isDerivation) (builtins.attrValues pkgs.nerd-fonts);
  };
}
