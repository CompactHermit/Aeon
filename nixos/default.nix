{ self, config, inputs,lib, ... }:
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      common.imports = [
        ./nix.nix
        ./services
        ./desktop
          # {
           #_module.args.lib = lib; ## To creeate custom lib.
        # }
      ];

      server.imports = [];

      my-home = {
        users.users.${config.people.myself} = {
          isNormalUser = true;
          extraGroups = [
            "adbusers"
            "wheel"
            "input"
            "networkmanager"
            "libvirtd"
            "video"
            "taskd"
            "docker"
            "plugdev"
            "seat"
          ];
        };
        home-manager.users.${config.people.myself} = {
          imports = [
            self.homeModules.default
          ];
        };
      };

      default.imports = [
        self.nixosModules.home-manager
        # self.nixosModules.my-home
        self.nixosModules.common
        inputs.ragenix.nixosModules.default
        inputs.nur.nixosModules.nur
        # inputs.impermanence.nixosModules.impermanence
        # ./audio.nix
        # ./services.nix
        # ./ssh-authorize.nix
        # ./location.nix
      ];
    };
  };
}
