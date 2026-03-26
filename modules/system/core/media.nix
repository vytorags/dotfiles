{ ... }:
{
  services = {
    jellyfin.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    prowlarr.enable = true;
    bazarr = {
      enable = true;
      listenPort = 6767;
    };

    transmission = {
      enable = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist-enabled = false;
        rpc-host-whitelist-enabled = false;
      };
    };
  };

  # Open ports to allow local network access to WebbUIs and Torrent Peers
  networking.firewall.allowedTCPPorts = [
    8096 # Jellyfin HTTP
    7878 # Radarr HTTP
    8989 # Sonarr HTTP
    9696 # Prowlarr HTTP
    9091 # Transmission RPC/WebUI
    51413 # Transmission Peer Port
    6767 # Bazarr HTTP
  ];

  networking.firewall.allowedUDPPorts = [
    51413 # Transmission Peer Port
  ];
}
