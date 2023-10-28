{pkgs, config,lib,...}: {
  home.packages = with pkgs; [
    zsh
    btop
    feh
    xsel
    lutgen
    spicetify-cli
    nushell
    atuin
    zoxide
    starship
    carapace
    fish # Nushell Kinda needs this  (╯°□°)╯︵ ┻━┻.
  ];

  programs = {
    # Don't really use it, but whatever
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };

    atuin = {
      enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
  };
}
