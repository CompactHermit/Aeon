{ lib, pkgs, ... }: {
  services.shiori = {
    enable = true;
    package = pkgs.shiori.overrideAttrs (_: {
      patches = [
        # Thanks mic92. very cool
        ../../contracts/_3Entities/0001-set-saner-postgresql-connection-default-and-make-use.patch
      ];
    });
    port = 4378;
  };
  systemd.services.shiori.environment = {
    SHIORI_PG_HOST = "/run/postgresql";
    SHIORI_PG_PORT = "5432";
    SHIORI_PG_USER = "shiori";
    SHIORI_PG_NAME = "shiori";
    SHIORI_PG_PASS = "shiori";
    SHIORI_DBMS = "postgresql";
  };
  systemd.services.shiori = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "shiori";
      Group = "shiori";
      RestrictAddressFamilies = [ "AF_UNIX" ];
      BindPaths = [ "/run/postgresql" ];
    };
  };
  users.users.shiori = {
    isSystemUser = true;
    home = "/var/lib/shiori";
    group = "shiori";
  };
  users.groups.shiori = { };
}
