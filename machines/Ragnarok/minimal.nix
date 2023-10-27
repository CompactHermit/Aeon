{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mapAttrs' nameValuePair mkForce;
in {
  environment.systemPackages = with pkgs; [
    neovim
    vim
    curl
    wget
    httpie
    networkmanager
    diskrsync
    partclone
    ntfsprogs
    ntfs3g
  ];

  # Use helix as the default editor
  environment.variables.EDITOR = "nvim";

  networking = {
    firewall.enable = false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    usePredictableInterfaceNames = false;
  };

  services.resolved.enable = false;

  systemd = {
    network.enable = true;
    services.update-prefetch.enable = false;
    services.sshd.wantedBy = mkForce ["multi-user.target"];
  };

  documentation = {
    enable = false;
    nixos.options.warningsAreErrors = false;
    info.enable = false;
  };

  nix = {
    gc.automatic = true;

    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = ${inputs.flake-registry}/flake-registry.json
    '';

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
  };


  system.stateVersion = "23.05";
}
