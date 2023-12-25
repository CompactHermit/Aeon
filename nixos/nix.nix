{
  flake,
  pkgs,
  ...
}: {
  nixpkgs = {
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "zotero-6.0.27"
      ];
    };
    overlays = [
      flake.inputs.firefox-nightly.overlays.firefox
      flake.inputs.nuenv.overlays.nuenv
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
    package = pkgs.nixUnstable;
    nixPath = ["nixpkgs=${flake.inputs.nixpkgs}"]; # Enables use of `nix-shell -p ...` etc
    registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes repl-flake auto-allocate-uids";
      # Nullify the registry for purity.
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      # netrc-file = /home/${flake.config.people.myself}/.netrc;
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      sandbox = true;
    };
    extraOptions = ''
      min-free = 536870912
      fallback = true
    '';
  };
}
