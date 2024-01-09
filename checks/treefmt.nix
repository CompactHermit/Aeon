{ ... }: {
  perSystem = { pkgs, config, ... }: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = { nixfmt.enable = true; };
    };
  };
}
