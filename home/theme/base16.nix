{flake,...}:{
  config = {
    theme.base16 = {
      enable = true;
      path = "${flake.inputs.oxocarbon16}/base16-oxocarbon-dark.yaml";
    };
  };
}
