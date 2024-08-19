{ config, ... }:
let
  devices = {
    Genghis = [ ];
    Alexander = [ ];
    Caesar = [ ];
    Tell = [ ];
  };
  allDevs = builtins.attrValues devices;
  __code-V = {
    type = "staggered";
    params = {
      cleanInterval = "3600"; # 1 hour in seconds
      maxAge = "15552000"; # 180 days in seconds
    };
  };
  __book-V = {
    type = "simple";
    params = {
      keep = "10";
    };
  };
in
{
  sops.secrets."syncthing-gui-password" = {
    group = "users";
  };

  services.syncthing = {
    enable = true;
    user = "CompactHermit";
    dataDir = "/home/CompactHermit";
    openDefaultPorts = true;
    configDir = "/home/CompactHermit/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    group = "users";
    settings = {
      devices = {
        "Genghis" = {
          id = "MR7FCXB-L5M4EWR-NTAOOJZ-JPGN3QW-4PTX3DG-M5B4K42-SS7IZ3C-Z7ISRAR";
        }; # TODO: SOPS!
      };
      folders = {
        "Neorg_Notes" =
          {
            path = "/home/CompactHermit/neorg";
            devices = [ "Genghis" ];
          }
          // {
            versioning = __code-V;
          };
        "Docs" =
          {
            path = "/home/CompactHermit/Programming/Notes/Math/";
            devices = [ "Genghis" ];
            ignorePerms = false;
          }
          // {
            versioning = __code-V;
          };
        "sync" = {
          path = "~/sync";
          devices = [ "Genghis" ];
          copyOwnershipFromParent = true;
        };
        "Library" =
          {
            path = "~/Library";
            devices = [ "Genghis" ];
            ignorePerms = false;
          }
          // {
            versioning = __book-V;
          };
        "ArxivDB" =
          {
            path = "~/arxiv_papers";
            devices = [ "Genghis" ];
            ignorePerms = false;
          }
          // {
            versioning = __book-V;
          };
      };
      gui = {
        # NOTE:: (Hermit) Sops doesn't allow the file to be read, why
        user = "CompactHermit";
        password = config.sops.secrets."syncthing-gui-password".path;
      };
    };
    guiAddress = "0.0.0.0:8384";
  };
}
