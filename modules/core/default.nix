{ ... }:
{
  imports = [
    ./user.nix
    ./udisk.nix
    ./polkit.nix
    ./zram.nix
    ./accountservice.nix
    ./thermald.nix
    ./ccache.nix
    ./ananicy.nix
    ./scx.nix
  ];
}
