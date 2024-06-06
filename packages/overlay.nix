{ flake, system, ... }:
self: super: {
  hermit-bar = self.callPackage ./taffybar/default.nix { };
  ico-patched = self.callPackage ./icomoon.nix { };
  coogler = self.callPackage ./coogler/coogler.nix { inherit (flake) inputs; };
  # carapace = self.callPackage ./carapace.nix { inherit (flake) inputs; };
  #floorp = self.callPackage ./floorp.nix { inherit (flake) inputs; };
}
