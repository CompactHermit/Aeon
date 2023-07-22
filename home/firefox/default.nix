{ pkgs
, lib
, config
, inputs
, ...
}: 
let
  l = lib // builtins;
in {
  programs.firefox = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      then pkgs.firefox-bin
      else pkgs.firefox;
      profiles =
        let
          userChrome = with config.lib.base16.theme; ''
          '';
          userContent = with config.lib.base16.theme; ''
          '';
          settings = {
            "browser.ctrlTab.recentlyUsedOrder" = false;
            "browser.uidensity" = 1;
            "browser.urlbar.update1" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
            "services.sync.declinedEngines" = "addons,prefs";
            "services.sync.engine.addons" = false;
            "services.sync.engineStatusChanged.addons" = true;
            "services.sync.engine.prefs" = false;
            "services.sync.engineStatusChanged.prefs" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "gfx.webrender.all" = true;
            "general.smoothScroll" = true;
          };
        in
        {
          home = {
            id = 0;
            inherit settings;
            inherit userChrome;
            inherit userContent;
            extensions = with config.nur.repos.rycee.firefox-addons; [
              add-custom-search-engine
              amp2html
              betterttv
              reddit-enhancement-suite
              sideberry
              SurfingKeys
              TamperMonkey
              ublock-origin
              umatrix
            ];
          };
        };


      };

  programs.schizofox = {
    enable = true;

    theme = {
      background-darker = "181825";
      background = "1e1e2e";
      foreground = "cdd6f4";
      font = "Iosevka";
      simplefox.enable = true;
      darkreader.enable = true;
      extraCss = ''
      body {
        color: red !important;
      }
      '';
    };

    search = rec {
      defaultSearchEngine = "Searxng";
      removeEngines = ["Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia" "LibRedirect" "DuckDuckGo"];
      searxUrl = "https://search.notashelf.dev";
      searxQuery = "${searxUrl}/search?q={searchTerms}&categories=general";
      addEngines = [
        {
          Name = "Searxng";
          Description = "Decentralized search engine";
          Alias = "sx";
          Method = "GET";
          URLTemplate = "${searxQuery}";
        }
      ];
    };

    security = {
      sanitizeOnShutdown = false;
      sandbox = true;
      userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
    };

    misc = {
      drmFix = true;
      disableWebgl = false;
      startPageURL = "file://${./startpage.html}";
    };

    extensions.extraExtensions = {
      "1018e4d6-728f-4b20-ad56-37578a4de76".install_url = "https://addons.mozilla.org/firefox/downloads/latest/flagfox/latest.xpi";
      "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
      "sideberry".install_url = "https://addons.mozilla.org/firefox/downloads/file/4170134/sidebery-5.0.0.xpi";
      "tridactyl".install_url = "https://tridactyl.cmcaine.co.uk/betas/tridactyl-latest.xpi";
      "sponsorBlocker@ajay.app".install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
      "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
    };

    bookmarks = [
      {
        Title = "Covenant";
        URL = "https://github.com/CompactHermit/Aeon";
        Placement = "toolbar";
        Folder = "Github";
      }
    ];
  };
}
