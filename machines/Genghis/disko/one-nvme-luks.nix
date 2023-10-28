{ ... }:
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        # device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };

            swap = {
              label = "swap";
              size = "32G";
              content = {
                type = "swap";
                resumeDevice = true;
                randomEncryption = true;
              };
            };

            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "Yama";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                content = {
                  # content = {
#                 type = "lvm_pv";
#                 vg = "Aruha"; ## The LVM Group to point to
#               };
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "subvol=home" "compress=zstd" "noatime" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "subvol=log" "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    # lvm_vg = {}; # (For some odd readon, framework refuses to boot with this, lol)
  };
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}
#           #   #     };
#     lvm_vg = {
#       Aruha = {
#         type = "lvm_vg";
#         lvs = {
#           root = {
#             size = "900G";
#             content = {
#               type = "btrfs";
#             name = "swap";
#             size = "100%FREE";
#             content = {
#               type = "swap";
#             };

