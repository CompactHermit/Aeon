{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    zsh
    btop
    feh
    xsel
    wmctrl
    xdotool
    gh
    age
    himalaya
    sops
    playerctl
    bitwarden-cli
    lutgen
    atuin
    git-crypt
    zoxide
    nushell
    lm_sensors
    tree-sitter
    hyperfine
    ttags
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

    btop = {
      enable = true;
      settings = {
        color_theme = "nord"; ## TODO:: Make Oxocarbon btop Theme
        theme_background = true;
        truecolor = true;
        vim_keys = true;
      };
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

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };

    # himalaya = {
    #   enable = true;
    # };

    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
      extraConfig =
        /*
        nu
        */
        ''
            $env.config = ($env.config | merge {
              edit_mode: vi
              show_banner: false
            });

            register ${pkgs.nushellPlugins.query}/bin/nu_plugin_query

          # maybe useful functions
          # use ${pkgs.nu_scripts}/share/nu_scripts/modules/formats/to-number-format.nu *
          # use ${pkgs.nu_scripts}/share/nu_scripts/sourced/api_wrappers/wolframalpha.nu *
          # use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/job.nu *
          # use ${pkgs.nu_scripts}/share/nu_scripts/modules/network/ssh.nu *

          # completions
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/btm/btm-completions.nu *
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/cargo/cargo-completions.nu *
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/tealdeer/tldr-completions.nu *
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/poetry/poetry-completions.nu *
          use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/zellij/zellij-completions.nu *
        '';
    };
  };
  xdg.configFile."nushell/nu-zellij/mod.nu" = {
    source = ./nushell/nu-zellij.nu;
  };
}
