{ config, ... }:
{
  # Should open on port 8096
  services.nginx.virtualHosts = {
    "jelly.compacthermit.dev" = {
      forceSSL = true;
      sslCertificate = config.sops.secrets.ch_ssl_cert.path;
      sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;
        extraConfig = "proxy_pass_header Authorization;";
      };
    };

  };
  services.jellyfin = {
    enable = true;
    group = "jellyfin";
    user = "jellyfin";
    openFirewall = true;
  };
}
