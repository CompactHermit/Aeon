{inputs,...}:{

  perSystem =  {config,pkgs,...}:{
    packages.coogler =  {
      pname = "coogler";
      src = inputs.coogler;
    };
  };
}
