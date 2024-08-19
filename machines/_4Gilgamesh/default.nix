{
  flake,
  modulesPath,
  lib,
  pkgs,
  ...
}:
let
  swapsize = "32GB";
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports =
    [
      self.nixosModules.wayland
      flake.inputs.disko.nixosModules.disko
      flake.inputs.preservation.nixosModules.default
      ./disko.nix
      (modulesPath + "/installer/scan/not-detected.nix")
    ]
    ++ (with flake.inputs.nixos-hardware.nixosModules; [
      gpd-pocket-4
    ]);

  environment.variables.EDITOR = "nvim";
  system.stateVersion = "23.05";

  services = {
    fwupd.enable = true;
    fprintd = {
      # enable = lib.mkForce false;
      enable = true;
      package = pkgs.fprintd.overrideAttrs (_: {
        mesonCheckFlags = [
          "--no-suite"
          "fprintd:TestPamFprintd"
        ];
      });
    };
    openssh.enable = true;
    power-profiles-daemon.enable = true;
  };
  nix.monitored = {
    notify = false;
    enable = true;
  };
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  };
  hardware = {
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
    opengl.enable = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
  };
  systemd = {
    services.NetworkManager-wait-online.enable = lib.mkForce false;
    services.update-prefetch.enable = false;
    services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
  };
  networking = {
    networkmanager = {
      wifi.scanRandMacAddress = false;
      enable = true;
    };
    useDHCP = lib.mkForce true; # (Hermit) I, what, why, for what reason????
    usePredictableInterfaceNames = false;
    wireless.enable = false;
    firewall = {
      allowedTCPPorts = [
        443
        80
        8448
        22000
      ];
      allowedUDPPorts = [
        443
        80
        21027
      ];
      enable = true;
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      #"8.8.8.8"
      #"8.8.4.4"
    ];
    # extraHosts = lib.mkForce ''
    #   10.10.10.xxx genghis
    #   10.10.10.xxx Adjoint
    #   10.10.10.xxx Faker
    # '';
  };
  boot = {
    tmp.cleanOnBoot = true;
    loader.grub = {
      device = "nodev";
      enable = true;
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_6_14;
    # kernelParams = [
    #   "amd_iommu=on"
    #   "video=eDP-1:2256x1504@60"
    #   "video=DP-2:1920x1080@60"
    #   "video=DP-4:1920x1080@60"
    # ];
  };
  security.sudo.wheelNeedsPassword = false;
  users.users.root.hashedPasswordFile = "/persist/passwords/root";
  networking.hostName = "Wyze";
  networking.domain = "compacthermit.dev";

}
