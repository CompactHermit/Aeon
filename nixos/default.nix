{ self, config, inputs, ... }:
{
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      shared.imports = [
        ./nix.nix
      ];

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

      system.imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.sops-nix.nixosModules.sops
        inputs.nur.nixosModules.nur
        self.nixosModules.shared
        # ./secure-boot.nix
        ./services
        # ./persist.nix
      ];
      wayland.imports = [];


      xmonad.imports = [
        self.nixosModules.home-manager
        self.nixosModules.my-home
        ./audio.nix
        ./desktop
        # ./ssh-authorize.nix
        ./location.nix
      ];
    };
  };
}
