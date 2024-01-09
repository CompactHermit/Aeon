{ config, flake, lib, pkgs, ... }:
let
  cfgs = config.services;
  cfgp = config.sops.secrets;
in {
  imports = [ flake.inputs.mailserver.nixosModules.mailserver ];
  sops.secrets = {
    "ch_mail_admin" = { };
    "ch_mail_pass" = { };
    "ch_ms_matrix" = { };
    "ch_ms_vault" = { };
  };
  mailserver = {
    enable = true;
    fqdn = "mail.compacthermit.dev";
    domains = [ "compacthermit.dev" ];
    lmtpSaveToDetailMailbox = "no";
    recipientDelimiter = "+-";
    fullTextSearch = {
      enable = true;
      autoIndex = true;
      indexAttachments = true;
      # * Only works for plain text, weird
      enforced = "body";
    };
    mailboxes = {
      Archive = {
        auto = "subscribe";
        specialUse = "Archive";
      };
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
      };
      Trash = {
        auto = "subscribe";
        specialUse = "Trash";
      };
    };
    loginAccounts = {
      # * Admin
      "ragnarok@compacthermit.dev" = {
        hashedPasswordFile = cfgp.ch_mail_admin.path;
        aliases = [
          "faker@compacthermit.dev"
          "faker"
          "ragnarok"
          "admin"
          "root"
          "postmaster"
        ];
      };

      "genghis@compacthermit.dev" = {
        aliases = [ "genghis" ];
        hashedPasswordFile = cfgp.ch_mail_pass.path;
      };

      # * Needed for creating vaultwarden accounts
      "vaultwarden@compacthermit.dev" = lib.mkIf cfgs.vaultwarden.enable {
        aliases = [ "vaultwarden" "vault" ];
        hashedPasswordFile = cfgp.ch_ms_vault.path;
      };

      # TODO:: (Hermit) Add conduit
      # * Needed for creating matrix accounts
      # "matrix@compacthermit.dev" = lib.mkIf cfgs.matrix.enable {
      #   aliases = ["matrix"];
      #   hashedPasswordFile = cfgp.ch_ms_matrix.path;
      #   };
    };
    certificateScheme = "manual"; # Manual:: We to add a custom pem file
    keyFile = cfgp.ch_ssl_key.path;
    certificateFile = cfgp.ch_ssl_cert.path;
  };
  #security.acme.acceptTerms = true;
  #security.acme.defaults.email = "security@compacthermit.dev";
  #
  services = {
    roundcube = {
      enable = true;
      database.username = "roundcube";
      maxAttachmentSize = 50;
      dicts = with pkgs.aspellDicts; [ en de ];
      hostName = "webmail.compacthermit.dev";
      extraConfig = ''
        $config['imap_host'] = array(
          'tls://mail.compacthermit.dev' => "compacthermit's Mail Server",
          'ssl://imap.gmail.com:993' => 'Google Mail',
          );
          $config['username_domain'] = array(
            'mail.compacthermit.dev' => 'compacthermit.dev',
            'mail.gmail.com' => 'gmail.com',
            );
            $config['x_frame_options'] = false;
          # starttls needed for authentication, so the fqdn required to match
          # the certificate
          $config['smtp_host'] = "tls://${config.mailserver.fqdn}";
          $config['smtp_user'] = "%u";
          $config['smtp_pass'] = "%p";
          $config['plugins'] = [ "carddav" ];
      '';
    };

    # * For blocklisting mails
    postfix = {
      dnsBlacklists = [
        "all.s5h.net"
        "b.barracudacentral.org"
        "bl.spamcop.net"
        "blacklist.woody.ch"
      ];
      dnsBlacklistOverrides = ''
        compacthermit.dev OK
        mail.compacthermit.dev OK
        127.0.0.0/8 OK
        192.168.0.0/16 OK
      '';
      headerChecks = [{
        action = "IGNORE";
        pattern = "/^User-Agent.*Roundcube Webmail/";
      }];
      config = { smtp_helo_name = config.mailserver.fqdn; };
    };

    phpfpm.pools.roundcube.settings = {
      "listen.owner" = config.services.nginx.user;
      "listen.group" = config.services.nginx.group;
    };
  };
}
