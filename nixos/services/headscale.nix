{config, ...}: let
  domain = "hs.compacthermit.dev";
  port = 8095;
in {
  environment.systemPackages = [config.services.headscale.package];
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = port;
      settings = {
        serverUrl = "https://${domain}";
        logtail.enabled = false;
        dns_config = {
          base_domain = "compacthermit.dev";
          domains = ["${domain}"];
        };
      };
    };
  };
}
