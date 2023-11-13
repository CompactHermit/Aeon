{self',pkgs,...}:{
  perSystem = {
    pkgs,
    inputs,
    flake,
    ...
  }:
  let

    # TODO!: Make the crane wasm-builders a custom lib:: inherit (flake.lib) mkRustWasm
    rustWithWasiTarget = pkgs.rust-bin.nightly.latest.default.override {
      extensions = [ "rust-src" "rust-std"];
      targets = [ "wasm32-wasi" ];
    };
    craneLib = (inputs.crane.mkLib pkgs).overrideToolchain rustWithWasiTarget;
  in {
    packages.zworkspaces = craneLib.buildPackage {
      src = craneLib.cleanCargoSource (craneLib.path inputs.zworkspaces);
      cargoExtraArgs = "--target wasm32-wasi";
      doCheck = false;
      buildInputs = [
        pkgs.libiconv
      ];
    };
  };
}
