{ pkgs, config, lib, ... }:
let
  cfg = config.services.arxiv;
  inherit (lib) mkOption mkIf makeBinPath mkEnableOption;
in {
  options.services.arxivterminal = {
    enable = mkEnableOption (lib.mkdoc "Enable Arxiv Terminal Database");
    location = mkOption { };
  };

  config.services.arxivterminal = lib.mkIf cfg.enable {
    systemd.services.arxiv-fetch = {
      reloadIfChanged = false;
      restartIfChanged = false;
      stopIfChanged = false;
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      startAt = "*:0/30";
      serviceConfig = { DynamicUser = true; };

      path = with pkgs; [ pkgs.arxivterminal pkgs.jq pkgs.curl ];
      script = "";
    };
  };
}
