{ pkgs, config, ... }:
let droneserver = config.users.users.droneserver.name;
in {
  sops.secrets."postgres-gitea_dbpass" = {
    owner = config.services.gitea.user;
  };

  services.gitea = {
    enable = true;
    stateDir = "/persist/services/gitea";
    package = pkgs.forgejo;
    appName = "Gitea on Nix";
    settings = {
      server = {
        DOMAIN = "git.compacthermit.dev";
        ROOT_URL = "https://git.compacthermit.dev/";
        LANDING_PAGE = "/explore/repos";
        HTTP_ADDR = "/run/gitea/gitea.sock";
        PROTOCOL = "http+unix";
        UNIX_SOCKET_PERMISSION = "660";
      };
      "git.timeout" = {
        DEFAULT = 720;
        MIGRATE = 30000;
        MIRROR = 72000;
        CLONE = 30000;
        PULL = 30000;
        GC = 60;
      };
      service.DISABLE_REGISTRATION = true;
    };
    database = {
      type = "postgres";
      socket = "/run/postgresql";
      createDatabase = true;
    };
  };
}
