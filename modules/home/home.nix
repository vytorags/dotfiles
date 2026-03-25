{
  config,
  pkgs,
  unstable,
  lib,
  role ? "desktop",
  ...
}:
let
  isDesktop = role == "desktop";
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ./programs
  ];

  home = {
    username = "vitor";
    homeDirectory = lib.mkForce "/home/vitor";
    stateVersion = "25.05";
    packages =
      with pkgs;
      [
        gnome.gvfs
        nautilus
        bc
        imagemagick
        qimgv
        usbutils
        usbredir
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
      ]
      ++ lib.optionals isDesktop [
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
      ];

    sessionVariables = {
      TERMINAL = "wezterm";
      EDITOR = "nvim";
      WLR_DRM_NO_ATOMIC = 1;
      QT_QPA_PLATFORM = "wayland;xcb";
      NIXOS_OZONE_WL = "1";
    };

    file.".face".source = ../../assets/profile.png;
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
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

  nix.registry = {
    dev = {
      from = {
        id = "dev";
        type = "indirect";
      };
      to = {
        type = "path";
        path = "${config.home.homeDirectory}/nixdots";
      };
    };
  };
}
