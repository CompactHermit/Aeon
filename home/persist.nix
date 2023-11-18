{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.persistence = {
    "/persist/home/CompactHermit" = {
      directories = [
        "Documents"
        "Downloads"
        "Zotero"
        "Library"
        "Wallpapers"
        "Videos"
        "Music"
        ".config"
        ".gnupg"
        ".local"
        ".ssh"
      ];
      allowOther = true;
    };
  };
}
