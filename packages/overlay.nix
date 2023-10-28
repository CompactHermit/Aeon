{flake,system,...}:
  self: super: {
    #arxiv-terminal = self.callPackage ./arxiv_terminal.nix;
    oxocarbon-gtk = self.callPackage ./oxocarbon.nix {};
  }
