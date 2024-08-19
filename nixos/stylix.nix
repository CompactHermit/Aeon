{
  pkgs,
  flake,
  ...
}:
{
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../assets/oxocarbon.png;
    base16Scheme = flake.inputs.nix-colors.colorSchemes.oxocarbon-dark;
    opacity = {
      terminal = 0.9;
      popups = 0.9;
      desktop = 0.9;
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
    };
  };
}
