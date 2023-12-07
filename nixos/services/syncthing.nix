{config, ...}: let
  devices = {
    Genghis = [
      /*
      place ID here
      */
    ];
    Alexander = [
      /**/
    ];
    Caesar = [
      /**/
    ];
  };
  allDevs = builtins.attrValues devices;
in {
  sops.secrets."syncthing/gui-password/password" = {
    group = "users";
  };

  services.syncthing = {
    enable = true;
    user = "CompactHermit";
    dataDir = "/home/CompactHermit";
    openDefaultPorts = true;
    configDir = "/home/CompactHermit/.config/syncthing";
    group = "users";
    settings = {
      devices = {
        "Genghis" = {id = "MR7FCXB-L5M4EWR-NTAOOJZ-JPGN3QW-4PTX3DG-M5B4K42-SS7IZ3C-Z7ISRAR";}; #TODO: SOPS!
      };
      folders = {
        "Neorg_Notes" = {
          path = "/home/CompactHermit/neorg";
          devices = ["Genghis"];
        };
        "Docs" = {
          path = "/home/CompactHermit/Programming/Notes/Math/";
          devices = ["Genghis"];
          ignorePerms = false;
        };
        "sync" = {
          path = "~/sync";
          devices = ["Genghis"];
          copyOwnershipFromParent = true;
        };
      };
      gui = {
        user = "CompactHermit";
        password = "cat ${config.sops.secrets."syncthing/gui-password/password".path}";
      };
    };
    guiAddress = "0.0.0.0:8384";
  };
}
# trace: warning: The option `services.syncthing.extraOptions' defined in `/nix/store/8p76k81062k30q6v3cqh48ps2hv034sd-source/nixos/services/syncthing.nix' has been renamed to `services.syncthing.settings'.

