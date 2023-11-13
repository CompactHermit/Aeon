{ self,inputs,flake, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        # TODO:: (Hermit) Add custom mkModule Lib for path recursion
        imports = [
          # ./tmux.nix
          inputs.nur.hmModules.nur
          inputs.nix-index-database.hmModules.nix-index
          ./zellij
          # ./neovim
          ./yazi
          ./dunst.nix
          ./picom.nix
          ./shell.nix
          ./git.nix
          ./kitty.nix
          ./gtk.nix
          # ./theme
          #./persist.nix
          # ./yuzu.nix
          ./gui.nix
          # ./emacs
          ./firefox
        ];
      };

      default = {pkgs,...}:{
        imports = [
          self.homeModules.common
        ];
        programs = {
          nix-index-database.comma.enable = true;
          home-manager.enable = true;
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
