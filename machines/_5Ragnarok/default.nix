{ self, inputs, ... }:
#TODO::(Hermit) Make this a proper module, fucking loser
{
  perSystem =
    { self', pkgs, ... }:
    let
      inherit (inputs) nixos-generators;

      defaultModule =
        { ... }:
        {
          imports = [
            inputs.disko.nixosModules.disko
            ./minimal.nix
          ];
          _module.args.self = self;
          _module.args.inputs = inputs;
        };
    in
    {
      packages = {
        Ragnarok = nixos-generators.nixosGenerate {
          inherit pkgs;
          format = "install-iso";
          modules = [
            defaultModule
            (
              {
                config,
                lib,
                pkgs,
                ...
              }:
              let
                # disko
                disko = pkgs.writeShellScriptBin "disko" "${config.system.build.diskoScript}";
                disko-mount = pkgs.writeShellScriptBin "disko-mount" "${config.system.build.mountScript}";
                disko-format = pkgs.writeShellScriptBin "disko-format" "${config.system.build.formatScript}";

                # system
                thomas = pkgs.writeShellScriptBin "Ragnarok-install" ''
                  set -euo pipefail

                  echo "Formatting disks..."
                  . ${disko-format}/bin/disko-format

                  echo "Mounting disks..."
                  . ${disko-mount}/bin/disko-mount

                  echo "Cloning Git Repo..."
                  if [ ! -d "$HOME/dotfiles/.git" ]; then
                    git clone https://github.com/CompactHermit/Aeon.git "$HOME/dotfiles"
                  fi

                  echo "Installing system..."
                  nixos-install --impure --flake .#Wyze

                  echo "Done!, now reboot and pray!"
                '';
              in
              {
                imports = [ ../_4Gilgamesh/disko.nix ];

                # we don't want to generate filesystem entries on this image
                disko.enableConfig = lib.mkDefault false;

                # add disko commands to format and mount disks
                environment.systemPackages = [
                  disko
                  disko-mount
                  disko-format
                  thomas
                ];
              }
            )
          ];
        };
      };
    };
}
