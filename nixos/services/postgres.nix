{
  pkgs,
  config,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    #dataDir = "/persist/services/postgresql";
    ensureDatabases = with config; [
      services.gitea.database.user
    ];
    settings.unix_socket_permissions = "0770";
  };
}
