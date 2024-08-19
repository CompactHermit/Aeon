{ inputs, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt = {
            enable = true;
            package = inputs.nixfmt-rfc.packages."x86_64-linux".default;
          };
        };
      };
    };
}
