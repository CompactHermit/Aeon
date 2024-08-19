{ pkgs, ... }:
{
  #will use swamp_gate later
  imports = [
    ./angrr.nix
    #./hydra.nix
    #./mail.nix #TODO:: (Hermit) Setup reverse DNS
    ./kmonad.nix
    ./monitors.nix
    ./chromadb.nix
    ./syncthing.nix
    # ./attic.nix
    ./searx.nix
    # ./vaultwarden.nix
    # ./ccache.nix
    # ./jellyfin.nix
    ./nginx.nix
    ./tailscale.nix
    ./gitea.nix
    ./postgres.nix
    ./spicetify.nix
    #./ollama.nix
    # ./cloudflare-warp.nix
    #./nextcloud.nix
    # ./headscale.nix
    # ./shiori.nix
    #./garage.nix
    #./fail2ban.nix
  ];
  #++ [./monitoring];
  services = {
    dbus.enable = true;
    #espanso.enable = true;
    flatpak.enable = true;
    tor.enable = true;
    tor.client.enable = true;
    printing = {
      enable = false;
      # drivers = [ pkgs.hplip ];
    };
    greenclip.enable = true;
    udisks2.enable = true;
  };

  programs.firejail.enable = true;
  programs.mtr.enable = true;
  programs.extra-container.enable = true;
  #programs.sysdig.enable = true;
}
