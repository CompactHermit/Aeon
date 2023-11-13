{...}:{
  services.syncthing = {
    enable = true;
    user = "CompactHermit";
    dataDir = "/home/CompactHermit";
    openDefaultPorts = true;
    configDir = "/home/CompactHermit/.config/syncthing";
    group = "users";
    folders = {
      "Neorg_Notes" = {       
        path = "/home/CompactHermit/neorg";    
        devices = [ "Genghis" ];      
    };
    "Docs" = {
      path = "/home/CompactHermit/Programming/Notes/Math/";
      devices = [ "Genghis" ];
      ignorePerms = false;     
    };
  };
    devices = {
      "Genghis" = { id = "MR7FCXB-L5M4EWR-NTAOOJZ-JPGN3QW-4PTX3DG-M5B4K42-SS7IZ3C-Z7ISRAR"; }; #TODO: SOPS!
    };
    guiAddress = "0.0.0.0:8384";
    extraOptions.gui = {
      user = "CompactHermit";
      password = "Password"; # TODO:: SOPS!
    };
  };
}
