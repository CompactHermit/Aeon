{ ... }:
{
  perSystem =
    {
      self',
      config,
      lib,
      pkgs,
      ...
    }:
    let
      flash-iso-image =
        name: image:
        let
          pv = "${pkgs.pv}/bin/pv";
          fzf = "${pkgs.fzf}/bin/fzf";
        in
        pkgs.writeShellScriptBin name ''
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
    in
    {
      packages = {
        Kepler_search = pkgs.writeShellScriptBin "Kepler" ''
          set -euo pipefail
          nix build .#nixosConfigurations.Kepler.config.system.build.toplevel
        '';
        Solomon_search = pkgs.writeShellScriptBin "Wyze" ''
          set -euo pipefail
          nix build .#nixosConfigurations.Wyze.config.system.build.toplevel
        '';
        Ragnarok_Install = flash-iso-image "Ragnarok-ISO" "Ragnarok";
      };
    };
}
