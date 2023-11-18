{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.coogler = pkgs.buildRustPackages {
      name = "coogler";
      version = 0.0 .1;
      src = inputs.coogler;
      buildInputs = [];
    };
  };
}
