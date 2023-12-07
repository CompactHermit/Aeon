{
  pkgs,
  lib,
  config,
  ...
}: let
  l = lib // builtins;
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
  extensions = {
    rycee = config.nur.repos.rycee.firefox-addons;
    bandithedoge = config.nur.repos.bandithedoge.firefoxAddons;
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin;
    profiles = {
      Maxwell = {
        id = 0;
        inherit settings;
        # note:: Just directly grab rycees pkgs, you don't even use the NUR anyway
        extensions = with extensions; [
          rycee.sidebery
          rycee.tridactyl
          rycee.tampermonkey
          rycee.ublock-origin
          rycee.umatrix
          rycee.bitwarden
          rycee.user-agent-string-switcher
          bandithedoge.sourcegraph
          rycee.c-c-search-extension
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
