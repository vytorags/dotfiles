{ pkgs, ... }:
{
  programs.gamemode = {
    enable = true;

    settings = {
      general = {
        renice = 5;
        softrealtime = "auto";
      };

      cpu = {
        governor = "schedutil";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
}
