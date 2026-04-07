{
  config,
  pkgs,
  unstable,
  ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ../programs/niri
    ../programs/noctalia
    ../programs/wezterm
    ../programs/sioyek
    ../programs/fastfetch
    ../programs/cava
    ../programs/lazygit
    ../programs/vesktop
  ];

  home.packages = with pkgs; [
    gnome.gvfs
    nautilus
    imagemagick
    qimgv
    gpu-screen-recorder
    prismlauncher
    (writeShellApplication {
      name = "minecraft";
      runtimeInputs = [
        gamemode
        prismlauncher
        util-linux
      ];
      text = ''
        exec taskset -c 0-3 gamemoderun prismlauncher
      '';
    })
    localsend
    deskflow
    sonobus
    wf-recorder
    gifski
    grim
    slurp
    zbar
    translate-shell
    tesseract
    unstable.gowall
    krita
    system-config-printer
    libreoffice
    pokemon-colorscripts
    prismlauncher
    android-tools
    obs-studio
    waydroid
    ppsspp
    protonvpn-gui
    (writeShellApplication {
      name = "scrolllock_keyboard";
      runtimeInputs = [
        pkgs.brightnessctl
        pkgs.procps
      ];
      text = ''
        DEV="input*::scrolllock"
        STATE_FILE="/tmp/scrolllock_active"

        if [ -f "$STATE_FILE" ]; then
          rm "$STATE_FILE"
          pkill -f "scrolllock_daemon" || true
          brightnessctl --device="$DEV" set 0
          exit 0
        fi

        touch "$STATE_FILE"
        echo "none" | brightnessctl --device="$DEV" set 1

        (
          exec -a scrolllock_daemon sh -c '
            while [ -f /tmp/scrolllock_active ]; do
              if [ "$(brightnessctl --device="input*::scrolllock" get)" -eq 0 ]; then
                brightnessctl --device="input*::scrolllock" set 1
              fi
              sleep 0.2
            done
          '
        ) & disown
      '';
    })
    anki
    evtest
  ];

  home.sessionVariables = {
    WLR_DRM_NO_ATOMIC = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    NIXOS_OZONE_WL = "1";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.bookmarks = [
      "file://${homeDir}/Documents"
      "file://${homeDir}/Downloads"
      "file://${homeDir}/Pictures"
      "file://${homeDir}/Videos"
      "file://${homeDir}/Music"
      "file://${homeDir}/Workspace"
      "file://${homeDir}/nixdots"
    ];
  };

  qt.enable = true;
}
