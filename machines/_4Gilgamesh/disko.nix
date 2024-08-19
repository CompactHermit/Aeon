{
  disko.devices = {
    disk.Gilgamesh = {
      # device = "${config.system.devices.rootDisk}";
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            # priority = 1;
            label = "esp";
            type = "ef00";
            size = "512M";
            content = {
              mountOptions = [ "umask=0077" ];
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          Tomes = {
            # priority = 2;
            size = "100%";
            content = {
              type = "luks";
              name = "Solomon";
              content = {
                type = "lvm_pv";
                vg = "Solomon_pool";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      Solomon_pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            name = "swap";
            size = "32GB";
            content = {
              type = "swap";
            };
          };
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              subvolumes =
                let
                  mountOptions = [
                    "compress=zstd:1"
                    "noatime"
                  ];
                in
                {
                  "root" = {
                    inherit mountOptions;
                    mountpoint = "/";
                  };
                  "nix" = {
                    inherit mountOptions;
                    mountpoint = "/nix";
                  };
                  "state" = {
                    inherit mountOptions;
                    mountpoint = "/state";
                  };
                  "persist" = {
                    inherit mountOptions;
                    mountpoint = "/persist";
                  };
                };
            };
          };
        };
      };
    };
  };
  fileSystems."/state".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
}
