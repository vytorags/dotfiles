{ config, pkgs, lib, ... }: {
  services.tailscale.enable = true;
  
  systemd.services.tailscaled = {
    serviceConfig = {
      Restart = lib.mkForce "always";
    };
  };
}
