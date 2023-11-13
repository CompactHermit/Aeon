{ self,inputs,flake, ... }:
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
          # ./theme
          #./persist.nix
          ./yuzu.nix
          ./gui.nix
          ./emacs # My Beloved
          ./firefox
        ];
      };

      default = {pkgs,...}:{
        imports = [
          inputs.nix-index-database.hmModules.nix-index
          inputs.nur.hmModules.nur
          self.homeModules.common
        ];
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
