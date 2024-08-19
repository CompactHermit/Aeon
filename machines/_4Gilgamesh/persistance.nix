{ config, ... }:
{

  preservation = {
    enable = true;
    preserveAt = {
      "/state" = {
        directories = [
          "/etc/nixos"
          "/etc/secureboot"

          "/var/db/sudo"
          "/var/lib/bluetooth"
          "/var/lib/fprint"
          "/var/lib/libvirt"
          {
            directory = "/var/lib/nixos";
            inInitrd = true;
          }
          "/var/lib/systemd"
          "/var/cache"
          "/var/log"
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
            how = "symlink";
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key";
            mode = "0700";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_ed25519_key.pub";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key";
            mode = "0700";
            inInitrd = true;
          }
          {
            file = "/etc/ssh/ssh_host_rsa_key.pub";
            inInitrd = true;
          }
        ];
        users.wyze = {
          directories = [
            "docs"
            "music"
            "pics"
            "public"
            "src"
            "vids"
            ".zen"
            ".background"
            ".config/dconf"
            ".config/nvim"
            ".config/jj"
            ".config/Mattermost"
            ".config/obs-studio"
            ".config/pipewire"
            ".config/PrusaSlicer"
            ".config/rncbc.org"
            {
              directory = ".gnupg";
              mode = "0700";
            }
            ".local/share/fish"
            ".local/share/mopidy"
            ".local/share/nvim"
            ".local/share/PrismLauncher"
            ".local/share/anime-borb-launcher/"
            ".local/share/honkers-railway-launcher"
            ".local/share/yuzu"
            ".local/share/zoxide"
            ".local/share/atuin"
            ".local/state/waydroid"
            ".local/state/wireplumber"
            ".zotero/"
            "Zotero/"
            {
              directory = ".ssh";
              mode = "0700";
            }
          ];
          files = [
            {
              file = ".android/adbkey";
              configureParent = true;
            }
            {
              file = ".android/adbkey.pub";
              configureParent = true;
            }
            {
              file = ".config/beets/library.db";
              configureParent = true;
            }
            {
              file = ".config/beets/state.pickle";
              configureParent = true;
            }
            ".lmmsrc.xml"
          ];
        };
      };

      "/persist" = {
        users.wyze = {
          directories = [
            "iso"
            "tmp"
            {
              directory = ".cargo/registry";
              configureParent = true;
            }
          ];
        };
      };
    };
  };

  systemd.tmpfiles.settings.preservation = {
    "/home/wyze/.config".d = {
      user = "wyze";
      group = "users";
      mode = "0755";
    };
    "/home/wyze/.local".d = {
      user = "wyze";
      group = "users";
      mode = "0755";
    };
    "/home/wyze/.local/share".d = {
      user = "wyze";
      group = "users";
      mode = "0755";
    };
    "/home/wyze/.local/state".d = {
      user = "wyze";
      group = "users";
      mode = "0755";
    };
  };

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/state/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /state"
    ];
  };

}
