{ self, inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        # TODO:: (Hermit) Add custom mkModule Lib for path recursion
        imports = [
          ./yazi
          ./dunst.nix
          ./picom.nix
          ./shell.nix
          ./git.nix
          ./kitty.nix
          ./gtk.nix
          #./persist.nix
          ./gui.nix
          #./firefox
        ];
      };

      default =
        { pkgs, ... }:
        {
          imports = [
            inputs.nix-index-database.hmModules.nix-index
            inputs.tmux-which-key.homeManagerModules.default
            self.homeModules.common
            #inputs.nur.hmModules.nur
            #./emacs # My Beloved
          ];

          xsession = {
            enable = true;
            preferStatusNotifierItems = true;
          };
          programs = {
            nix-index-database.comma.enable = true;
            home-manager.enable = true;
          };
          services = {
            udiskie = {
              enable = true;
              notify = true;
              automount = true;
              tray = "auto";
            };
            # Tests are failing, will check later
            # taffybar = {
            #   enable = true;
            #   package = pkgs.hermit-bar;
            # };
          };
        };

      darwin = {
        imports = [ self.homeModules.common ];
      };

      wayland = {
        imports = [
          self.homeModules.default
          ./yazi
          ./shell.nix
          ./git.nix
          ./kitty.nix
          ./gtk.nix
          ./niri.nix
          ./gui.nix
        ];
      };
      wsl = {
        imports = [
          self.homeModules.common
          # ./wsl_home
        ];
      };
    };
  };
}
