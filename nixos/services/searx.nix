{ config, pkgs, ... }:
{
  sops.secrets.searx_keys = { };
  users.users.${config.services.nginx.user}.extraGroups = [ "searx" ];
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    # runInUwsgi = true;
    # uwsgiConfig = {
    #   socket = "/run/searx/searx.sock";
    #   chmod-socket = "660";
    #   disable-logging = true;
    # };
    environmentFile = config.sops.secrets.searx_keys.path;
    settings = {
      general.instance_name = "Hermit search";
      server = {
        secret_key = config.sops.secrets.searx_keys.path;
        # base_url = "https://search.compacthermit.dev";
        port = 8888;
        bind_address = "127.0.0.1";
      };
      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
      ui = {
        static_use_hash = true;
        default_locale = "en";
        query_in_title = true;
        infinite_scroll = false;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "dark";
        search_on_category_select = false;
        hotkeys = "vim";
      };
      search.formats = [
        "html"
        "json"
      ];

      # TODO:: (Hermit) add Arxiv
      engines = [
        {
          name = "wikipedia";
          engine = "wikipedia";
          shortcut = "@w";
          base_url = "https://wikipedia.org/";
        }
        {
          name = "duckduckgo";
          engine = "duckduckgo";
          shortcut = "@ddg";
        }
        {
          name = "archwiki";
          engine = "archlinux";
          shortcut = "@aw";
        }
        {
          name = "github";
          engine = "github";
          categories = "it";
          shortcut = "@gh";
        }
        {
          name = "noogle";
          engine = "google";
          categories = "it";
          shortcut = "@ng";
        }
        {
          name = "hoogle";
          engine = "xpath";
          search_url = "https://hoogle.haskell.org/?hoogle={query}&start={pageno}";
          results_xpath = ''//div[@class="result"]'';
          title_xpath = ''./div[@class="ans"]'';
          url_xpath = ''./div[@class="ans"]//a/@href'';
          content_xpath = ''./div[contains(@class, "doc")]'';
          categories = "it";
          shortcut = "h";
        }
      ];
    };
  };
  #_file
  # services.nginx = {
  #   virtualHosts = {
  #     "search.compacthermit.dev" = {
  #       forceSSL = true;
  #       sslCertificate = config.sops.secrets.ch_ssl_cert.path;
  #       sslCertificateKey = config.sops.secrets.ch_ssl_key.path;
  #       locations."/".extraConfig = "uwsgi_pass unix:;/run/searx/searx.sock";
  #       extraConfig = "access_log off;";
  #     };
  #   };
  # };
}
