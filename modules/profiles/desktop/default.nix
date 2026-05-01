{
  pkgs,
  unstable,
  ...
}:
{
  imports = [
    ../../core/sddm.nix
    ../../core/niri.nix
    ../../core/portals.nix
    ../../core/bluetooth.nix
    ../../core/pipewire.nix
    ../../core/waydroid.nix
    ../../core/virt-manager.nix
    ../../core/opentablet.nix
    ../../core/gamemode.nix
    ../../core/flatpak.nix
    ../../core/docker.nix
    ../../core/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    telegram-desktop
    kdePackages.ark
    (brave.override {
      commandLineArgs = [
        "--password-store=gnome"
        "--ozone-platform=wayland"
        "--enable-features=UseOzonePlatform"
        "--enable-features=VaapiVideoDecoder"
        "--enable-features=BatterySaverModeAvailable"
      ];
    })
    gparted
    mpv
    freerdp
    grim
    slurp
    xwayland-satellite
    wl-clipboard
    wtype
    cliphist
    pamixer
    pavucontrol
    unstable.libsForQt5.qtstyleplugins
    unstable.libsForQt5.qt5ct
    unstable.libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qt5compat
    unstable.kdePackages.qt6ct
    unstable.kdePackages.qtmultimedia
    unstable.kdePackages.qtstyleplugin-kvantum
    libei
    obsidian
    cowsay
    cmatrix
  ];

  services.tailscale.enable = true;
}
