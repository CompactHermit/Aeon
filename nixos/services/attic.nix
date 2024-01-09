{ flake, config, ... }:
let
  port = 8000;
  domain = "cache.compacthermit.dev";
in {
  sops.secrets."attic_key" = { };
  imports = [ flake.inputs.attic.nixosModules.atticd ];

  environment.systemPackages =
    with flake.inputs.attic.packages."x86_64-linux"; [
      attic
      attic-client
    ];

  networking.firewall.allowedTCPPorts = [ port ];
  # Add user For service
  links.atticServer.protocol = "http";
  users = {
    users.atticd = {
      isSystemUser = true;
      group = "atticd";
      home = "/var/lib/atticd";
      createHome = true;
    };
    groups.atticd = { };
  };
  services.atticd = {
    enable = true;
    credentialsFile = config.sops.secrets.attic_key.path;
    user = "atticd";
    group = "atticd";
    settings = {
      listen = "127.0.0.1:${port}";
      allowed-hosts = [ "${domain}" ];
      database.url = "postgresql:///atticd?host=/run/postgresql";
      api-endpoint = "https://${domain}/";
      require-proof-of-possession = false;
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
