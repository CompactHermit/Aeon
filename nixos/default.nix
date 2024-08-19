{
  self,
  config,
  inputs,
  ...
}:
{
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
          imports = [ self.homeModules.default ];
        };
        home-manager.backupFileExtension = "backup";
      };
      system.imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.angrr.nixosModules.angrr
        inputs.aagl.nixosModules.default
        self.nixosModules.shared
        ./services
        ./android.nix
        ./virtualization.nix
      ];
      wayland.imports = [
        self.nixosModules.shared
        inputs.nix-monitored.nixosModules.default
        inputs.stylix.nixosModules.stylix
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.angrr.nixosModules.angrr
        inputs.aagl.nixosModules.default
        inputs.niri.nixosModules.niri
        (
          { config, ... }:
          {
            users.users."Wyze" = {
              isNormalUser = true;
              # hashedPasswordFile = config.sops.secrets.Wyze-password.path;
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
            };
            sops = {
              defaultSopsFormat = "yaml";
              defaultSopsFile = ../machines/_4Gilgamesh/secrets.yaml;
              age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              age.keyFile = "/var/lib/sops/key.txt"; # TODO:: Shift this over to /var/lib/sops bcs imperm
              age.generateKey = true;
            };
            home-manager.users."Wyze" = {
              imports = [ self.homeModules.default ];
            };
            home-manager.backupFileExtension = "backup";
          }
        )
        ./audio.nix
        ./gaming
        ./desktop/wayland
        # ./ssh-authorize.nix
        ./stylix.nix

      ];
      xmonad.imports = [
        #self.nixosModules.home-manager
        self.nixosModules.my-user
        inputs.nix-monitored.nixosModules.default
        inputs.stylix.nixosModules.stylix
        (
          { config, ... }:
          {
            sops = {
              defaultSopsFormat = "yaml";
              defaultSopsFile = ../machines/_3Genghis/secrets.yaml;
              age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
              age.keyFile = "/home/CompactHermit/.config/sops/age/keys.txt"; # TODO:: Shift this over to /var/lib/sops bcs imperm
              age.generateKey = true;
            };
          }
        )

        ./audio.nix
        ./desktop
        ./gaming
        ./ssh-authorize.nix
        ./location.nix
        ./stylix.nix
      ];
      wsl.imports = [
        inputs.wsl.nixosModules.wsl
        self.nixosModules.shared
        ./wsl
      ];

      mobile.imports = [
        self.nixosModules.shared
        ./stylix
        ./location.nix
      ];
    };
  };
}
