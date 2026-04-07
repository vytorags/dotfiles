{ pkgs, unstable, ... }:
{
  home = {
    packages = with pkgs; [
      ouch
      glow
      ripdrag
    ];
  };

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;

    initLua = ./main.lua;

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "M";
          run = "plugin mount";
        }
        {
          on = "L";
          run = "lazygit";
        }
        {
          on = [
            "P"
            "p"
          ];
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = "<C-n>";
          run = ''shell 'ripdrag "$@" -x 2>/dev/null &' --confirm'';
        }
        {
          on = "m";
          run = ''shell 'shell "$@"' --confirm'';
          desc = "Move selected items";
        }
        {
          on = "<C-s>";
          run = "plugin kdeconnect-send";
          desc = "Send selected files via KDE Connect";
        }
      ];
    };

    settings = {
      enable_mouse_support = true;

      log = {
        enabled = false;
      };

      mgr = {
        sort_dir_first = true;
        sort_reverse = true;
      };

      ratio = [
        1
        2
        4
      ];

      preview = {
        image_filter = "ueberzug";
        image_quality = 90;
        tab_size = 4;
        max_width = 1366;
        max_height = 760;
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      opener = {
        pdf = [
          {
            run = ''sioyek "$@" '';
            orphan = true;
            for = "unix";
          }
        ];
        img = [
          {
            run = ''qimgv "$@" '';
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            run = ''nvim "$@" '';
            block = true;
            for = "unix";
          }
        ];
        mpv = [
          {
            run = ''mpv "$@" '';
            orphan = true;
            for = "unix";
          }
        ];
        ark = [
          {
            run = ''ark "$@" '';
            orphan = true;
            for = "unix";
          }
        ];
        extract = [
          {
            run = ''ouch d -y "$@" '';
            desc = "Extract here with ouch";
            for = "unix";
          }
        ];

        EDITOR = [
          {
            run = ''nvim "$@"'';
            desc = "Run EDITOR";
          }
        ];
      };

      open = {
        prepend_rules = [
          {
            name = "*.pdf";
            use = "pdf";
          }
          {
            name = "*.jpg";
            use = "img";
          }
          {
            name = "*.png";
            use = "img";
          }
          {
            name = "*.gif";
            use = "img";
          }
          {
            name = "*.bmp";
            use = "img";
          }
          {
            name = "*.svg";
            use = "img";
          }
          {
            name = "*.ico";
            use = "img";
          }
          {
            name = "*.heic";
            use = "img";
          }
          {
            name = "*.jpeg";
            use = "img";
          }
          {
            name = "*.tiff";
            use = "img";
          }
          {
            name = "*.webp";
            use = "img";
          }
          {
            name = "*.mp4";
            use = "mpv";
          }
          {
            name = "*.zip";
            use = "ark";
          }
          {
            name = "*.tar";
            use = "ark";
          }
          {
            name = "*.gz";
            use = "ark";
          }
          {
            name = "*.bz2";
            use = "ark";
          }
          {
            name = "*.xz";
            use = "ark";
          }
          {
            name = "*.7z";
            use = "ark";
          }
          {
            name = "*.rar";
            use = "ark";
          }
          {
            name = "*.tar.gz";
            use = "ark";
          }
          {
            name = "*.tgz";
            use = "ark";
          }
          {
            name = "*.tar.bz2";
            use = "ark";
          }
          {
            name = "*.tbz2";
            use = "ark";
          }
          {
            name = "*.tar.xz";
            use = "ark";
          }
          {
            name = "*.txz";
            use = "ark";
          }
          {
            name = "*.lz";
            use = "ark";
          }
          {
            name = "*.lzma";
            use = "ark";
          }
          {
            name = "*.zst";
            use = "ark";
          }
          {
            name = "*.zstd";
            use = "ark";
          }
          {
            name = "*.cab";
            use = "ark";
          }
          {
            name = "*.iso";
            use = "ark";
          }
          {
            name = "*.apk";
            use = "ark";
          }
          {
            name = "*.jar";
            use = "ark";
          }
        ];
      };

      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "/";
            run = "git";
          }
        ];

        prepend_previewers = [
          # Archive previewer
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
          {
            mime = "application/xz";
            run = "ouch";
          }
          # Glow preview
          {
            name = "*.md";
            run = "glow";
          }
        ];
      };
    };

    plugins = with pkgs; {
      diff = yaziPlugins.diff;
      full-border = yaziPlugins.full-border;
      git = yaziPlugins.git;
      mount = yaziPlugins.mount;
      ouch = yaziPlugins.ouch;
      rich-preview = yaziPlugins.rich-preview;
      yatline = yaziPlugins.yatline;
      kdeconnect-send = ./plugins/kdeconnect-send.yazi;
    };
  };
}
