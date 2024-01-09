{ config, ... }:
let
  domain = "hs.compacthermit.dev";
  port = 8095;
in {
  environment.systemPackages = [ config.services.headscale.package ];
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = port;
      settings = {
        serverUrl = "https://${domain}";
        tls_cert_path = null;
        tls_key_path = null;
        logtail.enabled = false;
        dns_config = {
          base_domain = "compacthermit.dev";
          override_local_dns = true;
          magic_dns = true;
          domains = [ ];
          nameservers = [ "0.0.0.0" ];
        };
        derp.server = {
          enabled = true;
          region_id = 999;
          stun_listen_addr = "0.0.0.0:8100";

          auto_update_enable = true;
          update_frequency = "24h";
        };
        metrics_listen_addr = "127.0.0.1:8087";
      };
    };
  };
}
