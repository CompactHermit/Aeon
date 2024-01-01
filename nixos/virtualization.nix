{pkgs, ...}: {
  # Allows Nix to Crosscompile
  environment.systemPackages = with pkgs; [
    #FOR WAYDROID-ARKNIGHTS
    waydroid
    weston
  ];
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
    docker.enable = true;
    waydroid.enable = true;
  };
  containers.vpn = {
    config = {
      config,
      pkgs,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        protonvpn-cli
        zellij
        youtube-dl
        aria
      ];
      users.extraUsers.user = {
        isNormalUser = true;
        uid = 1000;
      };
    };
  };
}
