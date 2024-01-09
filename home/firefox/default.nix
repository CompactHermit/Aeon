{ pkgs, lib, flake, config, ... }:
let
  l = lib // builtins;
  settings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.ctrlTab.recentlyUsedOrder" = false;
    "browser.toolbars.bookmarks.visibility" = "always";
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

  extensions = flake.inputs.firefoxAddons.packages."x86_64-linux";
  prof = [ "Maxwell" "Laplace" "Leonidas" ];
in {
  imports = [ ];

  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin.override {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        OverrideFirstRunPage = "";
        #Extensions.Install = map (x: x.src.outPath) config.home-manager.users.tzlil.programs.firefox.profiles."Maxwell".extensions;
        SearchEngines.Default = "DuckDuckGo";
        ExtensionSettings = {
          "google@search.mozilla.org" = { installation_mode = "blocked"; };
          "amazondotcom@search.mozilla.org" = {
            installation_mode = "blocked";
          };
          "wikipedia@search.mozilla.org" = { installation_mode = "blocked"; };
          "bing@search.mozilla.org" = { installation_mode = "blocked"; };
        };
      };
    };
    profiles = {
      Maxwell = {
        id = 0;
        inherit settings;
        extensions = with extensions; [
          sidebery
          tridactyl
          ublock-origin
          privacy-possum
          bitwarden
          sourcegraph
          canvasblocker
          firenvim
          gitako-github-file-tree
        ];
      };
    };
  };

  home.file.".mozilla/firefox/Maxwell/chrome" = {
    source = ./chrome;
    recursive = true;
  };
}
