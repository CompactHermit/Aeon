{ self,inputs, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        imports = [
          ./tmux.nix
          ./starship.nix
          ./terminal.nix
          ./git.nix
          ./direnv.nix
          ./zellij.nix
          ./nushell
          ./kitty.nix
          ./emacs.nix

          ./firefox
        ];
      };

      default = {pkgs,...}:{
        imports = [
          self.homeModules.common
          inputs.shizofox.homeManagerModuleS
        ];

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
