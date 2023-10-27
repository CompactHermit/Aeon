{
  self,
  inputs,
  ...
}: {
  perSystem = {
    self',
    pkgs,
    ...
  }:
  let
    inherit (inputs) nixos-generators;

    defaultModule = {...}: {
      imports = [
        inputs.disko.nixosModules.disko
        ./minimal.nix
      ];
      _module.args.self = self;
      _module.args.inputs = inputs;
    };
  in {

    packages = {
      Ragnarok = nixos-generators.nixosGenerate {
        inherit pkgs;
        format = "install-iso";
        modules = [
          defaultModule
          ({
            config,
            lib,
            pkgs,
            ...
          }: let
            # disko
            system = self.nixosConfigurations.Kepler.config.system.build.toplevel;

          in {
            imports = [
              ../Genghis/disko/one-nvme-luks.nix
            ];

            # we don't want to generate filesystem entries on this image
            disko.enableConfig = lib.mkDefault false;

            # add disko commands to format and mount disks
          })
        ];
      };
    };
  };
}
