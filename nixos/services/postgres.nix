{ pkgs, config, ... }:
{
  services.postgresqlBackup.enable = true;
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    #dataDir = "/persist/services/postgresql";
    ensureDatabases = [
      "nextcloud"
      "gitea"
      "grafana"
      "vaultwarden"
      "roundcube"
      "headscale"
      "atticd"
      "shiori"
      "hydra"
    ];

    #TODO (Hermit):: MapAtts this shit
    ensureUsers = [
      {
        name = "postgres";
        ensureClauses = {
          superuser = true;
          login = true; # not implied by superuser
          createrole = true;
          createdb = true;
          replication = true;
        };
      }
      {
        name = "gitea";
        ensureDBOwnership = true;
      }
      {
        name = "hydra";
        ensureDBOwnership = true;
      }
      {
        name = "grafana";
        ensureDBOwnership = true;
      }
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
      {
        name = "roundcube";
        ensureDBOwnership = true;
      }
      {
        name = "headscale";
        ensureDBOwnership = true;
      }
      {
        name = "atticd";
        ensureDBOwnership = true;
      }
      {
        name = "shiori";
        ensureDBOwnership = true;
      }
    ];
    settings = {
      #unix_socket_permissions = "0770";
      superuser_reserved_connections = 3;
      shared_buffers = "1024 MB";
      max_connections = "300";
      work_mem = "32 MB";
      maintenance_work_mem = "320 MB";
      huge_pages = "off";
      effective_cache_size = "2 GB";
    };
  };
}
