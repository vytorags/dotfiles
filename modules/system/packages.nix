{
  pkgs,
  unstable,
  lib,
  role ? "desktop",
  isDesktop,
  ...
}:
{
  environment.systemPackages =
    with pkgs;
    [
      tree
      wget
      git
      unzip
      unrar
      ffmpeg
      zip
      brightnessctl
      nixos-shell
      docker-compose
      docker
      qemu
      avahi
      zsh
      eza
      home-manager
      upower
      exfatprogs
      yt-dlp
    ];

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.victor-mono
  ];
}
