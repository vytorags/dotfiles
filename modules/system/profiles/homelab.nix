{ ... }:
{
  imports = [
    ../core/docker.nix
  ];

  services.openssh.enable = true;
}
