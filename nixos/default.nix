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
        inputs.sops-nix.nixosModules.sops
        ./nix.nix
      ];
      my-user = {
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
      };
      system.imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.aagl.nixosModules.default
        self.nixosModules.shared
        ({config, ...}: {
          #NOTE:: (Hermit) Somehow, the flake.config variable is OOScope here, why?
          #SOPS
          sops = {
            defaultSopsFormat = "yaml";
            defaultSopsFile = ../machines/Genghis/secrets.yaml;
            age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            age.keyFile = "/home/CompactHermit/.config/sops/age/keys.txt"; # TODO:: SHift this over to /var/lib/sops bcs imperm stuffs
            age.generateKey = true;
          };
        })
        ./services
        ./android.nix
        ./virtualization.nix
        # ./secure-boot.nix
        # ./persist.nix
      ];
      wayland.imports = [];
      xmonad.imports = [
        self.nixosModules.home-manager
        self.nixosModules.my-user
        ./audio.nix
        ./desktop
        ./ssh-authorize.nix
        ./location.nix
      ];
      wsl.imports = [
        inputs.wsl.nixosModules.wsl
        ./wsl
      ];
    };
  };
}
