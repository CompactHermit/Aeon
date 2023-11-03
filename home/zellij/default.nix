{flake,system,...}:{
  programs.zellij = {
    enable = true;
    package = flake.inputs.zellij.packages."x86_64-linux".zellij;
  };

  home.file.".config/zellij" = {
    source = ./zellij;
    recursive = true;
  };

}
