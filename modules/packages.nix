{
  pkgs,
  unstable,
  lib,
  role ? "desktop",
  isDesktop,
  ...
}:
let
  corePackages = with pkgs; [
    tree
    wget
    git
    unzip
    zip
    zsh
    eza
    nixos-shell
    docker
    docker-compose
  ];

  desktopPackages = with pkgs; [
    unrar
    ffmpeg
    brightnessctl
    qemu
    avahi
    home-manager
    upower
    exfatprogs
    yt-dlp
    dconf
  ];
in
{
  environment.systemPackages = corePackages ++ lib.optionals isDesktop desktopPackages;

  fonts.packages = lib.optionals isDesktop (with pkgs; [
    font-awesome
    nerd-fonts.victor-mono
    material-symbols
  ]);
}
