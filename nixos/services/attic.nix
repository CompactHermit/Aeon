{flake,pkgs,...}:{
  imports = [
    flake.inputs.attic.nixosModules.atticd
  ];


  environment.systemPackages = with flake.inputs; [
    attic.packages."x86_64-linux".attic
  ];
  services.atticd = {
    enable = true;

    # TODO:: Make This secret with sopsnix
    credentialsFile = ./atticd.env;
    settings = {
      listen = "[::]:8080"; # 127.0.0.1::8080
      chunking = {
        nar-size-threshold = 64 * 1024; # 64 KiB
        min-size = 16 * 1024; # 16 KiB
        avg-size = 64 * 1024; # 64 KiB
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };
}
