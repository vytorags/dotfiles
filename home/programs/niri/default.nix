{ config, pkgs, ... }:
{
  xdg.configFile."niri/config.kdl".text = with config.lib.stylix.colors; ''
    output "HDMI-A-1" {
      mode "1440x900@74.997"
      scale 1
      position x=0 y=0
    }

    input {
      keyboard {
        xkb {
          layout "br"
        }
        numlock
      }

      touchpad {
        // off
        tap
        natural-scroll
      }

      mouse {
        // off
      }

      trackpoint {
        // off
      }
    }

    prefer-no-csd

    layout {
      gaps 12

      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        off
      }

      border {
        width 2
        active-color "#${base0D}"
        inactive-color "#505050"

        urgent-color "#9b0000"
      }

      shadow {
        softness 20

        spread 5

        offset x=0 y=5

        color "#0007"
      }

      struts {
        // left 64
        // right 64
        // top 64
        // bottom 64
      }
    }

    hotkey-overlay {
      skip-at-startup
    }

    environment {
      DISPLAY ":0"
      "QS_ICON_THEME" "${config.gtk.iconTheme.name}"
      "QT_QPA_PLATFORMTHEME" "qt5ct"
      "SSH_AUTH_SOCK" "/run/user/1000/keyring/ssh"
      "XDG_CURRENT_DESKTOP" "niri"
      "XDG_SESSION_DESKTOP" "niri"
    }

    spawn-at-startup "dbus-update-activation-environment --systemd --all"
    spawn-at-startup "eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)"
    spawn-at-startup "${pkgs.polkit_gnome}/bin/polkit-gnome-authentication-agent-1"
    spawn-at-startup "xwayland-satellite"
    spawn-sh-at-startup "noctalia-shell"
    spawn-at-startup "wl-paste --type text --watch cliphist store"
    spawn-at-startup "wl-paste --type image --watch cliphist store"

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    overview {
      zoom 0.5
    }

    gestures {
      hot-corners {
        off
      }
    }

    binds {
      Mod+Return { spawn "wezterm" "start"; }
      Mod+A { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
      Mod+V { spawn "noctalia-shell" "ipc" "call" "launcher" "clipboard"; }
      Mod+W { spawn "noctalia-shell" "ipc" "call" "plugin:wallcards" "toggle"; }
      Mod+P { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }
      Scroll_Lock { spawn "scrolllock_keyboard"; }
      Mod+E { spawn "wezterm" "start" "--" "yazi"; }
      Mod+C { spawn "wezterm" "start" "--" "nvim"; }
      Mod+B { spawn "brave"; }
      Alt+Insert { screenshot-window write-to-disk=true; }
      Ctrl+Alt+Delete { quit; }
      Ctrl+Insert { screenshot-screen write-to-disk=true; }
      Insert { screenshot; }
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+BracketLeft { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Comma { consume-window-into-column; }
      Mod+Ctrl+Down { move-window-down; }
      Mod+Ctrl+End { move-column-to-last; }
      Mod+Ctrl+F { expand-column-to-available-width; }
      Mod+Ctrl+H { move-column-left; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+I { move-column-to-workspace-up; }
      Mod+Ctrl+J { move-window-down; }
      Mod+Ctrl+K { move-window-up; }
      Mod+Ctrl+L { move-column-right; }
      Mod+Ctrl+Left { move-column-left; }
      "Mod+Ctrl+Page_Down" { move-column-to-workspace-down; }
      "Mod+Ctrl+Page_Up" { move-column-to-workspace-up; }
      Mod+Ctrl+R { reset-window-height; }
      Mod+Ctrl+Right { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }
      Mod+Ctrl+U { move-column-to-workspace-down; }
      Mod+Ctrl+Up { move-window-up; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollLeft { move-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
      Mod+Down { focus-window-down; }
      Mod+End { focus-column-last; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+F { maximize-column; }
      Mod+H { focus-column-left; }
      Mod+Home { focus-column-first; }
      Mod+I { focus-workspace-up; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }
      Mod+Left { focus-column-left; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+O repeat=false { toggle-overview; }
      "Mod+Page_Down" { focus-workspace-down; }
      "Mod+Page_Up" { focus-workspace-up; }
      Mod+Period { expel-window-from-column; }
      Mod+Q { close-window; }
      Mod+R { switch-preset-column-width; }
      Mod+Right { focus-column-right; }
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }
      Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
      Mod+Shift+Down { focus-monitor-down; }
      Mod+Shift+E { quit; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+Shift+F { fullscreen-window; }
      Mod+Shift+H { focus-monitor-left; }
      Mod+Shift+I { move-workspace-up; }
      Mod+Shift+J { focus-monitor-down; }
      Mod+Shift+K { focus-monitor-up; }
      Mod+Shift+L { focus-monitor-right; }
      Mod+Shift+Left { focus-monitor-left; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+P { power-off-monitors; }
      "Mod+Shift+Page_Down" { move-workspace-down; }
      "Mod+Shift+Page_Up" { move-workspace-up; }
      Mod+Shift+R { switch-preset-window-height; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Shift+U { move-workspace-down; }
      Mod+Shift+Up { focus-monitor-up; }
      Mod+Shift+V { switch-focus-between-floating-and-tiling; }
      Mod+Shift+WheelScrollDown { focus-column-right; }
      Mod+Shift+WheelScrollUp { focus-column-left; }
      Mod+T { toggle-window-floating; }
      Mod+U { focus-workspace-down; }
      Mod+Up { focus-window-up; }
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollLeft { focus-column-left; }
      Mod+WheelScrollRight { focus-column-right; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
    }

    layer-rule {
      match namespace="^noctalia-overview*"
      place-within-backdrop true
    }

    layer-rule {
      match namespace="^noctalia-background*"
    }

    window-rule {
      opacity 0.9
      draw-border-with-background false

      focus-ring {
        width 2
        active-color "#957FB8"
        inactive-color "#505050"
      }

      geometry-corner-radius 20
      clip-to-geometry true
    }

    window-rule {
      match is-floating=true
      shadow { on; }
    }

    window-rule {
      match app-id="org.telegram.desktop"
      block-out-from "screencast"
    }

    window-rule {
      match app-id="zen"
      match app-id="firefox"
      match app-id="chromium-browser"
      match app-id="xdg-desktop-portal-gtk"
      scroll-factor 0.500000
    }

    window-rule {
      match app-id="zen"
      match app-id="firefox"
      match app-id="chromium-browser"
      match app-id="edge"
      match app-id="brave-browser"
      opacity 1.0
      open-maximized true
    }

    window-rule {
      match app-id="firefox" title="Picture-in-Picture"
      default-column-width { fixed 480; }
      default-window-height { fixed 270; }
      open-floating true
      default-floating-position relative-to="bottom-right" x=32 y=32
    }

    window-rule {
      match title="Picture in picture"
      open-floating true
      default-floating-position relative-to="bottom-right" x=32 y=32
    }

    window-rule {
      match title="Discord Popout"
      open-floating true
      default-floating-position relative-to="bottom-right" x=32 y=32
    }

    window-rule {
      match app-id="pavucontrol"
      open-floating true
    }

    window-rule {
      match app-id="pavucontrol-qt"
      open-floating true
    }

    window-rule {
      match app-id="com.saivert.pwvucontrol"
      open-floating true
    }

    window-rule {
      match app-id="dialog"
      open-floating true
    }

    window-rule {
      match app-id="popup"
      open-floating true
    }

    window-rule {
      match app-id="task_dialog"
      open-floating true
    }

    window-rule {
      match app-id="gcr-prompter"
      open-floating true
    }

    window-rule {
      match app-id="file-roller"
      open-floating true
    }

    window-rule {
      match app-id="org.gnome.FileRoller"
      open-floating true
    }

    window-rule {
      match app-id="nm-connection-editor"
      open-floating true
    }

    window-rule {
      match app-id="blueman-manager"
      open-floating true
    }

    window-rule {
      match app-id="xdg-desktop-portal-gtk"
      open-floating true
    }

    window-rule {
      match app-id="org.kde.polkit-kde-authentication-agent-1"
      open-floating true
    }

    window-rule {
      match app-id="pinentry"
      open-floating true
    }

    window-rule {
      match title="Progress"
      open-floating true
    }

    window-rule {
      match title="File Operations"
      open-floating true
    }

    window-rule {
      match title="Copying"
      open-floating true
    }

    window-rule {
      match title="Moving"
      open-floating true
    }

    window-rule {
      match title="Properties"
      open-floating true
    }

    window-rule {
      match title="Downloads"
      open-floating true
    }

    window-rule {
      match title="file progress"
      open-floating true
    }

    window-rule {
      match title="Confirm"
      open-floating true
    }

    window-rule {
      match title="Authentication Required"
      open-floating true
    }

    window-rule {
      match title="Notice"
      open-floating true
    }

    window-rule {
      match title="Warning"
      open-floating true
    }

    window-rule {
      match title="Error"
      open-floating true
    }
  '';
}
