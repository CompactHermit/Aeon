{
  config,
  pkgs,
  ...
}: {
  sops.secrets.searx_keys = {};
  users.users.${config.services.nginx.user}.extraGroups = ["searx"];
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    runInUwsgi = true;
    uwsgiConfig = {
      socket = "/run/searx/searx.sock";
      chmod-socket = "660";
      disable-logging = true;
    };
    environmentFile = config.sops.secrets.searx_keys.path;
    settings = {
      general.instance_name = "Hermit search";
      server = {
        secret_key = "@SEARXNG_SECRET@";
        base_url = "https://search.compacthermit.dev";
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
          results_xpath = "//div[@class=\"result\"]";
          title_xpath = "./div[@class=\"ans\"]";
          url_xpath = "./div[@class=\"ans\"]//a/@href";
          content_xpath = "./div[contains(@class, \"doc\")]";
          categories = "it";
          shortcut = "h";
        }
      ];
      ui.theme_args.simple_style = "dark";
    };
  };
  #_file
}
