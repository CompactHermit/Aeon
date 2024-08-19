{ config, ... }:
{
  sops.secrets."Vaultwarden" = { };

  systemd.services.backup-vaultwarden.serviceConfig = {
    User = "root";
    Group = "root";
  };

  services = {
    vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets.Vaultwarden.path;
      backupDir = "/srv/storage/vaultwarden/backup";
      config = {
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        extendedLogging = true;
        invitationsAllowed = false;
        useSyslog = true;
        logLevel = "warn";
        showPasswordHint = false;
        signupsAllowed = false;
        signupsVerify = true;
        #signupsDomainsWhitelist = "compacthermit.dev";
        #smtpAuthMechanism = "Login";
        #smtpFrom = "vaultwarden@compacthermit.dev"; # TODO:: (Hermit) add simple mailserver
        #smtpFromName = "Hermit's Vault";
        #smtpHost = "mail.compacthermit.dev";
        #smtpPort = 465;
        smtpSecurity = "force_tls";
        dataDir = "/srv/storage/vaultwarden";
      };
    };
  };
}
