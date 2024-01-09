{ flake, config, lib, ... }: {
  #TODO::(Hermit) Make Gen-Keys function
  sops.secrets = lib.genAttrs [ "ch_ssl_key" "ch_ssl_cert" ] (_: {
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
      #   sslCertificate = config.sops.secrets.ch_ssl_cert.path;
      #   sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
      #   forceSSL = true;
      # };
      # "mail.compacthermit.dev" = {
      #   sslCertificate = config.sops.secrets.ch_ssl_cert.path;
      #   sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
      #   forceSSL = true;
      # };
      "search.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".extraConfig =
          "uwsgi_pass unix:${config.services.searx.uwsgiConfig.socket};";
        extraConfig = "access_log off;";
      };
      "sync.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".extraConfig = ''
          proxy_set_header        Host $host;
          proxy_set_header        X-Real-IP $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header        X-Forwarded-Proto $scheme;

          proxy_pass              http://localhost:8384/;

          proxy_read_timeout      600s;
          proxy_send_timeout      600s;
        '';
      };
      "git.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".proxyPass =
          "http://unix:${config.services.gitea.settings.server.HTTP_ADDR}";
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
          proxyPass = "http://127.0.0.1:${
              toString config.services.vaultwarden.config.ROCKET_PORT
            }";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
      "next.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
      };
      "shiori.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".proxyPass = "http://localhost:4378";
      };
      "cache.compacthermit.dev" = {
        extraConfig = ''
          client_max_body_size 0;
          proxy_read_timeout 300s;
          proxy_send_timeout 300s;
        '';
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://127.0.0.1:8080";
        };
      };
      "hs.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations = {
          "/" = {
            proxyPass =
              "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
          "/web" = {
            root = "${
                flake.inputs.nyxpkgs.packages."x86_64-linux".headscale-ui
              }/share";
          };
        };
      };
      "drone.compacthermit.dev" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets.ch_ssl_cert.path;
        sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
        locations."/".proxyPass = "http://localhost:3030/";
      };
    };
  };
}
