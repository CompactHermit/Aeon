{ pkgs, config, ... }: {
  home.packages = [ pkgs.yuzu-mainline ];

  home.persistence = {
    "/persist/home/${config.people.myself}" = {
      allowOther = true;
      directories = [ "Games/Yuzu" ".config/yuzu" ".local/share/yuzu" ];
    };
  };
}
