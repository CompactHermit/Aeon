{ ... }: {
  perSystem = { self', config, lib, pkgs, ... }:
    let
      flash-iso-image = name: image:
        let
          pv = "${pkgs.pv}/bin/pv";
          fzf = "${pkgs.fzf}/bin/fzf";
        in pkgs.writeShellScriptBin name ''
          set -euo pipefail

          # Build image
          nix build .#${image}

          # Display fzf disk selector
          iso="./result/iso/"
          iso="$iso$(ls "$iso" | ${pv})"
          dev="/dev/$(lsblk -d -n --output RM,NAME,FSTYPE,SIZE,LABEL,TYPE,VENDOR,UUID | awk '{ if ($1 == 1) { print } }' | ${fzf} | awk '{print $2}')"

          # Format
          ${pv} -tpreb "$iso" | sudo dd bs=4M of="$dev" iflag=fullblock conv=notrunc,noerror oflag=sync
        '';
    in {
      mission-control.scripts = {
        Kepler_search = {
          category = "Nix";
          description = "Builds toplevel NixOS image for Kepler host";
          exec = pkgs.writeShellScriptBin "Kepler" ''
            set -euo pipefail
            nix build .#nixosConfigurations.Kepler.config.system.build.toplevel
          '';
        };

        # ISOs
        Ragnarok-ISO = {
          category = "Images";
          description = "Flash installer-iso image for Ragnarok";
          exec = flash-iso-image "Ragnarok-ISO" "Ragnarok";
        };

      };
    };
}
