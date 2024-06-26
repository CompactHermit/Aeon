{ pkgs, ... }: {
  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #wireplumber.enable = true;
    #media-session.enable = true;
  };
  environment.systemPackages = with pkgs; [
    cmus
    pavucontrol
    pulsemixer
    alsa-utils
  ];
}
