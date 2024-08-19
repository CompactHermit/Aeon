{
  flake,
  config,
  pkgs,
  ...
}:
let
  ##TODO:: ->> NVFetcher
  sessionizer = pkgs.fetchFromGitHub {
    owner = "amtoine";
    repo = "tmux-sessionizer";
    rev = "d4a621e6c5a9f87b6da4f02203cba74af62a3bf5";
    hash = "sha256-1bxkm+s6rpBmOH2IPEJ2zLSPs9+Gm0zfA5wc4LtfZXk=
";
  };

in
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      jujutsu
      jj-fzf
      zsh
      btop
      feh
      xsel
      wmctrl
      xdotool
      gh
      age
      glow
      himalaya
      hexyl
      sops
      playerctl
      bitwarden-cli
      lutgen
      atuin
      git-crypt
      zoxide
      nushell
      lm_sensors
      hyperfine
      starship
      carapace
      tmux-sessionizer
      fish # Nushell Kinda needs this  (╯°□°)╯︵ ┻━┻.
      ;
  };

  home.file.".cache/atuin/init.nu" = {
    source = ./nushell/atuin.nu;
  };
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
      # enableFishIntegration = true;
    };
    fish = {
      enable = true;
      generateCompletions = true;
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair)
            name
            src
            ;
        }
        {
          inherit (pkgs.fishPlugins.puffer)
            name
            src
            ;
        }
      ];
      functions = {
        e = "nvim $argv";
        #nix run nixpkgs#<pkg> -- All flags
        nrv = "nix run nixpkgs#$argv[1] --Lvv -- $argv[2..-1]";
        nr = "nix run nixpkgs#$argv[1]  -- $argv[2..-1]";
        ne = "nix eval --expr argv[1..-1]";
      };
      interactiveShellInit = ''
        bind \ce 'nvim'
        bind \cy 'yazi'
        bind \cb backward-kill-word
        bind \ct complete-and-search
      '';
      shellAbbrs = {
        nv = "nvim";
        jcu = "journalctl --user -xeu";
        jc = "journalctl -xeu";
      };
    };
    btop = {
      enable = true;
      settings = {
        #color_theme = "nord"; # # TODO:: Make Oxocarbon btop Theme
        #theme_background = true;
        truecolor = true;
        vim_keys = true;
      };
    };
    atuin = {
      enable = true;
      enableNushellIntegration = false;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      #enableNushellIntegration = true;
      #settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
      extraConfig =
        # nu
        ''
                $env.config = ($env.config | merge {
                  edit_mode: vi
                  show_banner: false
                });


              # maybe useful functions
              # use ${pkgs.nu_scripts}/share/nu_scripts/modules/formats/to-number-format.nu *
              # use ${pkgs.nu_scripts}/share/nu_scripts/sourced/api_wrappers/wolframalpha.nu *
              # use ${pkgs.nu_scripts}/share/nu_scripts/modules/background_task/job.nu *

              # completions
              use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu *
              use ${pkgs.nu_scripts}/share/nu_scripts/modules/network/ssh.nu *
              use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/btm/btm-completions.nu *
          #use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/poetry/poetry-completions.nu *
              use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/cargo/cargo-completions.nu *
              use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu *
          #use ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/tealdeer/tldr-completions.nu *
        '';
    };
    tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
      # terminal = "tmux-256color";
      plugins = builtins.attrValues {
        inherit (pkgs.tmuxPlugins)
          resurrect
          ;
      };
      tmux-which-key = {
        enable = true;
        settings = import ./tmux/tmux-which-key.nix;
      };
      extraConfig =
        let
          colors = config.stylix.generated.palette;
        in
        #tmux
        ''
          set escape-time 1 # in ms
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes '"nu-nvim" "nu->ssh" log "nu->btop" btop nvim'

          set -g allow-passthrough on
          set -g visual-activity off # for image-nvim to work

          # ===REBINDS===
          unbind M-Space
          set -g prefix M-Space
          bind M-Space send-prefix

          #===Alt-Mappings===
          #For M-HJKL
          bind-key -n M-h select-pane -L
          bind-key -n M-j select-pane -D
          bind-key -n M-k select-pane -U
          bind-key -n M-l select-pane -R


          bind-key -T -r M-J resize-pane -D 1
          bind-key -T -r M-K resize-pane -U 1
          bind-key -T -r M-H resize-pane -L 1
          bind-key -T -r M-L resize-pane -R 1


          #===WhichKey===
          bind y send-keys "tmux capture-pane -p -S - | nvim -c 'set buftype=nofile' +" Enter
          bind-key -T copmy-ode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -sel clip > /dev/null"
          bind-key -T copy-mode-vi v send-keys " "
          bind-key p run "xclip -o -sel clip | tmux load-buffer - ; tmux paste-buffer"

          bind Space select-window -t :1

          # rebind splits to be easier to remember
          unbind '|'
          unbind '-'
          bind v split-window -hc "#{pane_current_path}"
          bind s split-window -vc "#{pane_current_path}"

          #Source file
          bind r source-file ~/.config/tmux/tmux.conf

          # Choose windows based on `time`
          bind s choose-tree -Zs -O time

          # rebind swapping window around, this makes intuitive sense.
          bind -r "<" swap-window -d -t -1
          bind -r ">" swap-window -d -t +1

          # resizing panes  with prefix Ctrl + h/j/k/l
          # so now you can hold ctrl + space and then hit the hjkl keys to resize
          bind -r C-j resize-pane -D 1
          bind -r C-k resize-pane -U 1
          bind -r C-h resize-pane -L 1
          bind -r C-l resize-pane -R 1

          # moving around with prefix hjkl
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # next tab with prefix t (this is just way more comfortable for me to type)
          bind-key -n -r M-m next-window
          bind-key -n -r M-n previous-window

          #Zellij-Like Window Switch::
          bind-key -n M-u choose-tree
          #Rename::
          bind-key -r -T prefix_a r command-prompt -I "#W" { rename-window "%%" }

          # OTHER OPTIONS
          set -g base-index 1 #0 Is hard with this wheel
          set -g renumber-windows on
          set -g mouse on # mouse support
          set -g pane-border-status top
          set -g history-limit 20000 # default was 2000
          # new window is c by the way
          bind c new-window -c "#{pane_current_path}" # keep path when creating a new window 

          #Ricing::
          set -g pane-active-border fg="#${colors.base03}"
          set -g pane-border-style fg="#${colors.base0C}"
          set -g pane-border-format "#{pane_index}.#{pane_title}::#{pane_current_command}"

          set -sa terminal-overrides ',xterm-256color:Tc'
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colors

          set -g focus-events on

          source "~/.config/tmux/conf/bar.conf"
          source "~/.config/tmux/tmux-nushell.conf"
        '';
    };
  };
  # xdg.configFile."nushell/nu-zellij/mod.nu" = {
  #   source = ./nushell/nu-zellij.nu;
  # };
  services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };
  xdg.configFile."nushell/scripts/tmux-sessionizer.nu" = {
    source = "${sessionizer}/tmux-sessionizer.nu";

  };
}
