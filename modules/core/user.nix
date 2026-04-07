{ config, pkgs, vars, ... }:
{
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.${vars.username} = {
      isNormalUser = true;
      group = "${vars.username}";
      description = "${vars.fullName}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "kvm"
        "libvirtd"
        "plugdev"
        "video"
        "input"
      ];
      ignoreShellProgramCheck = true;
    };

    groups.${vars.username} = {};
  };
}
