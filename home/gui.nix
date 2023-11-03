{flake,pkgs,...}:
{
  home.packages = with pkgs; [
    zeal
    # zotero # CVE 5217, apparently it uses firefox v60?? lmao
    zathura
    discord
    webcord-vencord
    rofi
    dconf
    zotero
    betterlockscreen
  ];
  programs.rofi = {
    enable = true;
    cycle = true;
  };
  services.betterlockscreen = {
    enable = true;
  };
}
