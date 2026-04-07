{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "$(find \"$HOME/nixdots/home/programs/fastfetch/pngs/\" -name \"*.png\" | sort -R | head -1)";
        type = "kitty";
        height = 12;
        padding = {
          top = 2;
          right = 4;
        };
      };
      "display" = {
        "separator" = " ";
      };
      "modules" = [
        "break"
        "break"
        "break"
        {
          "type" = "title";
          "keyWidth" = 10;
        }
        "break"
        {
          "type" = "os";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "kernel";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "packages";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "shell";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "terminal";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "wm";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "uptime";
          "key" = " ";
          "keyColor" = "33";
        }
        {
          "type" = "media";
          "key" = "󰝚 ";
          "keyColor" = "33";
        }
        "break"
        "break"
      ];
    };
  };
}
