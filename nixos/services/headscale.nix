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
      serverUrl = "https://${domain}";
      settings = {
        logtail.enabled = false;
      };
      dns = {
        baseDomain = "compacthermit.dev";
        domains = ["${domain}"];
      };
    };
  };
}
