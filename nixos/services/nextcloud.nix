{ pkgs, config, ... }:
let domain = "next.compacthermit.dev";
in {
  sops.secrets.nextcloud = { owner = "nextcloud"; };
  users.users.nextcloud.extraGroups = [ "postgres" ];
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    nginx.recommendedHttpHeaders = true;
    https = true;
    hostName = "next.compacthermit.dev";
    home = "/srv/storage/nextcloud"; # TODO:: Move this to persist
    autoUpdateApps.enable = false;
    database.createLocally = true;
    maxUploadSize = "4G";
    enableImagemagick = true;
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit
      #news
        bookmarks deck forms;
    };
    config = {
      overwriteProtocol = "https";
      dbtype = "pgsql";
      adminpassFile = config.sops.secrets.nextcloud.path;
      adminuser = "admin-root";
      defaultPhoneRegion = "US";
    };
  };
}
