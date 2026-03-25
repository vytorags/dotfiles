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
      telegram-desktop
      kdePackages.ark
      (brave.override {
        commandLineArgs = [
          "--password-store=gnome"
          "--enable-features=VaapiVideoDecoder"
          "--disable-features=Vp9Decoder,Av1Decoder,WebRtcAllowInputVolumeAdjustment"
          "--use-gl=egl"
          "--ignore-gpu-blocklist"
          "--disable-gpu-rasterization"
          "--disable-oop-rasterization"
          "--enable-features=BatterySaverModeAvailable"
        ];
      })
      gparted
      mpv
      yt-dlp
      freerdp
      exfatprogs
      upower
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
      grim
      slurp
      xwayland-satellite
      wl-clipboard
      wtype
      cliphist
      zsh
      eza
      pamixer
      pavucontrol
      home-manager
      unstable.libsForQt5.qtstyleplugins
      unstable.libsForQt5.qt5ct
      unstable.kdePackages.qt6ct
      unstable.kdePackages.qtmultimedia
      unstable.kdePackages.qtstyleplugin-kvantum
      libei
    ]
    ++ lib.optionals isDesktop [
      obsidian
      cowsay
      cmatrix
      nbfc-linux
    ];

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.victor-mono
  ];
}
