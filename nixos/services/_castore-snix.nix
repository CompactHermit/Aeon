{
  config,
  pkgs,
  sources,
  ...
}:

let
  host = "snix-cache.example.com";
in

{
  imports = [ "${sources.snix-cache}/nix/module.nix" ];

  nixpkgs.overlays = [ (import sources.snix-cache { inherit pkgs; }).overlay ];

  services.snix-cache = {
    enable = true;

    inherit host;

    caches = {
      default = {
        maxBodySize = "50G";

        uploadPasswordFile = config.age.secrets."nginx-snix_cache_default".path;
        signingPasswordFile = config.age.secrets."nginx-snix_cache_default.signing".path;

        signingKeyFile = config.age.secrets."snix-cache-default_signing_key".path;
        publicKey = "default.snix-cache.example.com-1:numjqGylTs8nVaEl/jQ1Hp0tA0tmosMGq3awZVkCcWM=";
      };
    };
  };

  services.nginx.virtualHosts.${host} = {
    enableACME = true;
    forceSSL = true;
  };
}
