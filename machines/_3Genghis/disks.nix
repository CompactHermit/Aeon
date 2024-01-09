{ ... }: {
  disko.devices = {
    disk.Genghis = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            type = "EF00";
            start = "1MiB";
            end = "512MiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "Maxwell";
              content = {
                type = "lvm_pv";
                vg = "Maxwell_pool";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      Maxwell_pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            name = "swap";
            size = "32G";
            content = { type = "swap"; };
          };
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              subvolumes = {
                "root" = { mountpoint = "/"; };
                "nix" = { mountpoint = "/nix"; };
                "state" = { mountpoint = "/state"; };
                "persist" = { mountpoint = "/persist"; };
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
