{
  lib,
  isDesktop ? false,
  ...
}:
{
  imports = [
    ./niri.nix
    ./portals.nix
    ./bluetooth.nix
    ./user.nix
    ./virt-manager.nix
    ./udisk.nix
    ./sddm.nix
    ./polkit.nix
    ./zram.nix
    ./accountservice.nix
    ./pipewire.nix
    ./thermald.nix
    ./waydroid.nix
    ./nbfc.nix
  ]
  ++ lib.optionals isDesktop [
    ./opentablet.nix
    ./gamemode.nix
    ./flatpak.nix
    ./docker.nix
  ];
}
