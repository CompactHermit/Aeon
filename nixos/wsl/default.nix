{ pkgs, config, flake, ... }: {
  wsl = {
    enable = true;
    defaultUser = config.nzbr.user;
    startMenuLaunchers = true;
    wslConf.automount.root = "/drv";
  };
}
