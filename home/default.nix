{ self,inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        # TODO:: (Hermit) Add custom mkModule Lib for path recursion
        imports = [
          ./zellij
          ./yazi
          ./dunst.nix
          ./picom.nix
          ./shell.nix
          ./git.nix
          ./kitty.nix
          ./gtk.nix
          #./persist.nix
          ./yuzu.nix
          ./gui.nix
          ./firefox
        ];
      };

      default = {pkgs,...}:{
        imports = [
          inputs.nix-doom.hmModule
          inputs.nix-index-database.hmModules.nix-index
          inputs.nur.hmModules.nur
          self.homeModules.common
          ./emacs # My Beloved
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
          taffybar = {
            enable = true;
            package = self.packages."x86_64-linux".hermit-bar; #FUCK OVERLAYS, SCOPE ERASING SHITS
          };
        };
      };

      darwin = {
        imports = [
          self.homeModules.common
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
