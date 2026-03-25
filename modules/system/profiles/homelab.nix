{ pkgs, ... }:
{
  imports = [
    ../core/docker.nix
    ../core/nbfc.nix
  ];

  environment.systemPackages = with pkgs; [
    nbfc-linux
  ];

  services.openssh.enable = true;
}
