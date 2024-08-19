{ flake, system, ... }:
self: super: {
  hermit-bar = self.callPackage ./taffybar/default.nix { };
  ico-patched = self.callPackage ./icomoon.nix { };
  coogler = self.callPackage ./coogler/coogler.nix { inherit (flake) inputs; };
  zotero-with-speech = self.callPackage ./zotero7.nix { };
  # kitty-nightly = self.callPackage ./kitty/kitty-nightly.nix { };
  # carapace = self.callPackage ./carapace.nix { inherit (flake) inputs; };
  floorp = self.callPackage ./floorp.nix { inherit (flake) inputs; };
  lmstudio = self.callPackage ./lmstudio { };
  chromadb-nightly = self.python3.pkgs.callPackage ./chromdb-nightly.nix { };
}
