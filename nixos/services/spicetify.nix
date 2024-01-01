{flake, ...}: let
  spicetify-nix = flake.inputs.spicetify-nix;
  spicePkgs = spicetify-nix.legacyPackages;
in {
  imports = [
    spicetify-nix.nixosModules.default
  ];
  programs.spicetify = {
    enable = true;
    enabledExtensions = builtins.attrValues {
      inherit (spicePkgs."x86_64-linux".extensions) adblock hidePodcasts shuffle;
    };
    theme = spicePkgs."x86_64-linux".themes.dribbblish;
    colorScheme = "custom";
    customColorScheme = {
      # TODO:: (Hermit) Add oxocarbon theme
      text = "f8f8f8";
      subtext = "f8f8f8";
      sidebar-text = "79dac8";
      main = "000000";
      sidebar = "323437";
      player = "000000";
      card = "000000";
      shadow = "000000";
      selected-row = "7c8f8f";
      button = "74b2ff";
      button-active = "74b2ff";
      button-disabled = "555169";
      tab-active = "80a0ff";
      notification = "80a0ff";
      notification-error = "e2637f";
      misc = "282a36";
    };
  };
}
