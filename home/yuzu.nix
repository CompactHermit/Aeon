{ pkgs, config, ... }: {
  home.packages = [ pkgs.yuzu-mainline ];

  # NOTE!:: We'll just persist home-dirs, FUse is a bitch to deal with
  # home.persistence = {
  #   "/persist/home/${config.people.myself}" = {
  #     allowOther = true;
  #     directories = [ "Games/Yuzu" ".config/yuzu" ".local/share/yuzu" ];
  #   };
  # };
}
