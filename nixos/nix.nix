{ flake, pkgs, ... }:
{
  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "freeimage-unstable-2021-11-01"
        "jitsi-meet-1.0.8043"
      ];
    };
    #TODO:: Use composeMany
    overlays = [
      flake.inputs.attic.overlays.default
      flake.inputs.taffybar.overlays.default
      flake.inputs.zellij.overlays.nightly
      flake.inputs.angrr.overlays.default
      flake.inputs.nix-monitored.overlays.default
      flake.inputs.jj.overlays.default
      flake.inputs.niri.overlays.niri
      #flake.inputs.yazi.overlays.default
      #flake.inputs.emacs-overlay.overlays.default
      (self: super: {
        fprintd = flake.inputs.nixpkgs-stable.legacyPackages."x86_64-linux".fprintd;
        # nixos-rebuild = super.nix-direnv.override {
        #   nix = super.nix-monitored.override { withNotify = false; };
        # };
        # nix-direnv = super.nix-direnv.override {
        #   nix = super.nix-monitored.override { withNotify = false; };
        # };
        # nix = super.nix-monitored.override {
        #   # inherit (super) nix;
        #   withNotify = false;
        # };
      })
      (import ../packages/overlay.nix {
        inherit flake;
        inherit (pkgs) system;
      })
    ];
  };

  nix = {
    # let package = cfg.package.override { withNotify = cfg.notify; }; in
    # package = pkgs.nix-monitored.override { withNotify = false; };
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
      ];
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      auto-allocate-uids = true;
      sandbox = true;
      substituters = [
        "https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
    extraOptions = ''
      min-free = 536870912
      fallback = true
    '';
  };
}
