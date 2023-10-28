{...}:{
  programs.zellij = {
    enable = true;
  };
  home.file.".config/zellij" = {
    source = ./zellij;
    recursive = true;
  };

}
