{ flake, pkgs, ... }: {
  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];
    };
    overlays = [
      flake.inputs.firefox-nightly.overlays.firefox
      flake.inputs.attic.overlays.default
      flake.inputs.taffybar.overlay
      #flake.inputs.emacs-overlay.overlays.default
      (import ../packages/overlay.nix {
        inherit flake;
        inherit (pkgs) system;
      })
    ];
  };

  nix = {
    package = pkgs.nixVersions.git;
    nixPath = [
      "nixpkgs=${flake.inputs.nixpkgs}"
    ]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake =
      flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
      flake-registry = builtins.toFile "empty-flake-registry.json"
        ''{"flakes":[],"version":2}'';
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      auto-allocate-uids = true;
      sandbox = true;
    };
    extraOptions = ''
      min-free = 536870912
      fallback = true
    '';
  };
}
