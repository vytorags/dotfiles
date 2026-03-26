{ pkgs, ... }:
{
  imports = [
    ../core/docker.nix
    ../core/nbfc.nix
    ../core/media.nix
  ];

  environment.systemPackages = with pkgs; [
    nbfc-linux
    ncdu
  ];

  services.openssh.enable = true;
  services.caddy.enable = true;
  services.tailscale.enable = true;
  services.homepage-dashboard.enable = true;
  services.netdata.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };

  # Prevent the server from sleeping when the lid is closed
  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
  };
}
