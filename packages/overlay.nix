{flake,system,...}:
  self: super: {
    #arxiv-terminal = self.callPackage ./arxiv_terminal.nix {};
    # TODO:: Shift this to another repo, it's honestly unneeded and bloats
    #oxocarbon-gtk = self.callPackage ./oxocarbon.nix {};
    #coogler = flake.packages.coogler; # Too weak to use Jai
    #icomoon-patched =  self.callPackage ./icomoon-patched {};
  }  
