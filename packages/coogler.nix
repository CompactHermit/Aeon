{inputs,...}:{

  perSystem =  {config,pkgs,...}:{
    packages.coogler =  pkgs.buildRustPackages {
      pname = "coogler";
      src = inputs.coogler;
      buildInputs = [];
    };
  };
}
