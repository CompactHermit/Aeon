{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        fnlfmt.enable = true;
      };
    };
  };
}
