{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    # extraCompatPackages = [ pkgs.proton-ge-bin.steamcompattool ];
  };
  hardware.steam-hardware.enable = true;

  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      mangohud
      lact
      #bottles
      ;
  };

  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
      Nice = -10;
    };
    enable = true;
  };

  programs.gamemode.enable = true;
}
