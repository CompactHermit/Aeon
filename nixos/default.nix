{ self, config, inputs, ... }:
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      common.imports = [
        ./nix.nix
      ];

      system.imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        ./desktop
        # ./secure-boot.nix
        ./services # Hydra/Attic Services
        # ./persist.nix
      ];
      server.imports = [];

      my-home = {
        users.users.${config.people.myself} = {
          isNormalUser = true;
          extraGroups = [
            "adbusers"
            "wheel"
            "input"
            "uinput"
            "networkmanager"
            "libvirtd"
            "video"
            "taskd"
            "docker"
            "plugdev"
            "seat"
          ];
          # hashedPasswordFile = "/persist/passwords/${config.people.myself}";
        };
        home-manager.users.${config.people.myself} = {
          imports = [
            self.homeModules.default
          ];
        };
        programs.dconf.enable = true;
      };

      default.imports = [
        self.nixosModules.home-manager
        self.nixosModules.my-home
        self.nixosModules.common
        inputs.sops-nix.nixosModules.sops
        inputs.nur.nixosModules.nur
        ./audio.nix
        # ./ssh-authorize.nix
        ./location.nix
      ];
    };
  };
}
