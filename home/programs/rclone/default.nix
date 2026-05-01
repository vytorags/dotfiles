{ pkgs, ... }:
{
  programs.rclone.enable = true;

  systemd.user.services.rclone-obsidian-mount = {
    Unit = {
      Description = "Mount specific Brain folder from Google Drive";
      After = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount Brain:Brain %h/Workspace/Brain \
          --vfs-cache-mode full \
          --vfs-cache-max-size 6G \
          --vfs-cache-max-age 25h \
          --vfs-read-chunk-size 33M \
          --buffer-size 17M \
          --no-modtime
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/Workspace/Brain";
      Restart = "on-failure";
      RestartSec = "11s";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Workspace/Brain";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
