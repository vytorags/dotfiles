{ config, pkgs, lib, ... }: {
  services.caddy = {
    enable = true;
    # We enforce localhost binding or tailscale binding
    # Caddy is run as a systemd service, basic hardening is provided by default NixOS module
  };

  systemd.services.caddy = {
    serviceConfig = {
      Restart = lib.mkForce "always";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };
}
