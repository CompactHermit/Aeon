{
  flake,
  config,
  lib,
  ...
}:
let
  domain = "cache.compacthermit.dev";
in
{
  sops = {
    secrets."attic_key" = { };
    templates."atticd.env" = {
      owner = "atticd";
      content = ''
        ${config.sops.secrets.attic_key.path};
      '';
    };
  };
  #imports = [ flake.inputs.attic.nixosModules.atticd ];

  environment.systemPackages = builtins.attrValues {
    inherit (flake.inputs.attic.packages."x86_64-linux")
      attic
      attic-client
      ;
  };

  networking.firewall.allowedTCPPorts = [ 8081 ];
  # Add user For service
  users = {
    groups.atticd = { };
    users."atticd" = {
      isSystemUser = true;
      group = "atticd";
    };
  };

  systemd.services.atticd = {
    serviceConfig.DynamicUser = lib.mkForce false;
  };

  services.atticd = {
    user = "atticd";
    group = "atticd";
    environmentFile = config.sops.templates."attic_key".path;
    settings = {
      listen = "127.0.0.1:8081";
      #allowed-hosts = [ "${domain}" ];
      storage = {
        type = "local";
        path = "/tmp";
      };
      database.url = "postgresql:///atticd?host=/run/postgresql";
      #api-endpoint = "https://${domain}/";
      #require-proof-of-possession = false;
      chunking = {
        nar-size-threshold = 64 * 1024;
        min-size = 16 * 1024;
        avg-size = 64 * 1024;
        max-size = 256 * 1024;
      };
      garbage-collection = {
        interval = "24 hours";
        default-retention-period = "6 weeks";
      };
    };
  };
}
