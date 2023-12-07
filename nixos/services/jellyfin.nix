{...}: {
  # Should open on port 8096
  services.jellyfin = {
    enable = true;
    group = "jellyfin";
    user = "jellyfin";
    openFirewall = true;
  };
}
