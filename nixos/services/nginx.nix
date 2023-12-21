{
  config,
  lib,
  ...
}: {
  #TODO::(Hermit) Make Gen-Keys function
  sops.secrets =
    lib.genAttrs [
      "ch_ssl_key"
      "ch_ssl_cert"
    ]
    (_: {
      owner = config.services.nginx.user;
      inherit (config.services.nginx) group;
    });
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      # "webmail.compacthermit.dev" = {
      #   forceSSL = true;
      #   enableACME = true;
      # };
      # "mail.compacthermit.dev" = {
      #   forceSSL = true;
      #   sslCertificate = config.sops.secrets.ch_ssl_cert.path;
      #   sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
      #   locations."/" = {
      #     proxyPass = "http://mail";
      #   };
      # };
      "search.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".extraConfig = "uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};";
        extraConfig = "access_log off;";
      };
      "git.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".proxyPass = "http://unix:${config.services.gitea.settings.server.HTTP_ADDR}";
      };
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
      "vault.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "next.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
      };
      "hs.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".proxyPass = "http://localhost:${toString config.services.headscale.port}";
      };
    };
  };
}
