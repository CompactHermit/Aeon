{pkgs, ...}: {
  # Allows Nix to Crosscompile

  boot.binfmt = {
    emulatedSystems = ["aarch64-linux" "i686-linux"];
    registrations = {
      # aarch64 interpreter
      aarch64-linux = {
        interpreter = "${pkgs.qemu}/bin/qemu-aarch64";
      };
      # i686 interpreter
      i686-linux = {
        interpreter = "${pkgs.qemu}/bin/qemu-i686";
      };
    };
  };
  nix.settings.extra-sandbox-paths = ["/run/binfmt" "${pkgs.qemu}"];
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        ovmf.enable = true;
      };
    };
  };
}
