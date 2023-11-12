{ pkgs
, lib
, config
, ...
}:
let
  l = lib // builtins;
in {
  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin;
    profiles =
      let
          # userChrome = import ./userChrome.nix ;
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
        Maxwell = {
          id = 0;
          inherit settings;
            # inherit userChrome;
            extensions = with config.nur.repos.rycee.firefox-addons; [
              sidebery
              tridactyl
              tampermonkey
              ublock-origin
              umatrix
            ];
          };
          # Shavara = {};
        };

      };

      home.file.".mozilla/firefox/Maxwell/chrome" = {
        source = ./chrome;
        recursive = true;
      };

    }
