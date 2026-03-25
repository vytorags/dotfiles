{ ... }:
{
  imports = [
    ./user.nix
    ./udisk.nix
    ./polkit.nix
    ./zram.nix
    ./accountservice.nix
    ./thermald.nix
  ];
}
