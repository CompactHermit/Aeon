{config, ...}: {
  sops.secrets."postgres/gitea_dbpass" = {
    owner = config.services.gitea.user;
  };

  services.gitea = {
    enable = true;
    stateDir = "/persist/services/gitea";
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
      ui.DEFAULT_THEME = "arc-green";
      service.DISABLE_REGISTRATION = true;
    };
    database = {
      type = "postgres";
      socket = "/run/postgresql";
      createDatabase = true;
    };
  };
}
# services.gitea = {
#    enable = true;
#    appName = "My awesome Gitea server"; # Give the site a name
#    database = {
#      type = "postgres";
#      passwordFile = config.sops.secrets."postgres/gitea_dbpass".path;
#    };
#    domain = "git.my-domain.tld";
#    rootUrl = "https://git.my-domain.tld/";
#    httpPort = 3001;
#  };

