{
  self,
  config,
  inputs,
  ...
}: {
  # Configuration common to all Linux systems
  flake = {
    nixosModules = {
      shared.imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nur.nixosModules.nur
        inputs.sops-nix.nixosModules.sops
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
        self.nixosModules.shared
        ({config, ...}: {
          #SOPS
          sops = {
            defaultSopsFormat = "yaml";
            defaultSopsFile = ../machines/Genghis/secrets.yaml;
            age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            age.keyFile = "/home/CompactHermit/.config/sops/age/keys.txt"; # TODO:: SHift this over to /var/lib/sops bcs imperm stuffs
            age.generateKey = true;
          };
        })
        # ./secure-boot.nix
        ./services
        # ./persist.nix
      ];
      wayland.imports = [
        #Probably use something configured in lua
      ];
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
