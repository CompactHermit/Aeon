{ lib, config, ... }:
let

  cfg = config.services.arxiv;
  inherit (lib.modules) mkDefault mkDerivedConfig;
  inherit (lib) mkOption mkIf makeBinPath mkEnableOption;
  inherit (lib.types)
  ;
in {
  options = {
    enable = mkEnableOption { type = "something"; };

  };
  config = mkIf cfg.enable {
    sonarr = {
      enable = true;
      group = "multimedia";
    };
    radarr = {
      enable = true;
      group = "multimedia";
    };
    bazarr = {
      enable = true;
      group = "multimedia";
    };
    readarr = {
      enable = true;
      group = "multimedia";
    };
    prowlarr = { enable = true; };

  };

}
