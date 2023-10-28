{lib,pkgs,...}:
{
  home.packages = with pkgs; [
    zeal
    # zotero # CVE 5217, apparently it uses firefox v60?? lmao
    zathura
    vencord
    discord
    rofi
    dconf
  ];
  programs.rofi = {
    enable = true;
    cycle = true;
    theme = "./.";
  };
}
