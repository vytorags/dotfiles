{ config, pkgs, lib, ... }: {
  services.cloudflared = {
    enable = true;
    # Requires manual configuration of the tunnel token via cloudflared CLI
    # e.g., cloudflared service install <token>
  };

  systemd.services.cloudflared = {
    serviceConfig = {
      Restart = lib.mkForce "always";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };
}
