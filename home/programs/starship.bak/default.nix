{ config, ... }:
{
  programs.starship = {
    enable = true;
    # enableZshIntegration = true;

    settings = with config.lib.stylix.colors; {
      format = "[](bright-purple)$os[](bg:base02 fg:bright-purple)$directory[](bg:base01 fg:base02)$git_branch$git_status[](fg:base01)$line_break
$character";

      right_format = "[](base02)$cmd_duration[](fg:base01 bg:base02)[󰚭](fg:base04 bg:base01)[ ](fg:base01)";

      line_break.disabled = true;

      username = {
        show_always = true;
        style_user = "bg:base02 fg:base05";
        style_root = "bg:orange fg:base04";
        format = "[ $user ]($style)";
      };

      os = {
        disabled = false;
        style = "bg:bright-purple fg:base01";
      };

      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        AOSC = " ";
        Arch = " ";
        Artix = " ";
        CachyOS = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        Nobara = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };

      directory = {
        home_symbol = "  ~";
        style = "fg:bright-purple bg:base02";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:base01";
        format = "[[ $symbol $branch ](fg:base04 bg:base01)]($style)";
      };

      git_status = {
        style = "fg:base04 bg:base01";
        format = "[$all_status$ahead_behind ]($style)";
      };

      cmd_duration = {
        disabled = false;
        min_time = 0;
        show_milliseconds = true;
        style = "bg:base02";
        format = "[$duration ]($style)";
      };

      character = {
        disabled = false;
        success_symbol = "[❭](fg:#${base0B})"; # verde
        error_symbol = "[❭](fg:red)"; # vermelho
        vimcmd_symbol = "[❭](fg:#${base0B})";
        vimcmd_replace_one_symbol = "[❭](fg:purple)";
        vimcmd_replace_symbol = "[❭](fg:purple)";
        vimcmd_visual_symbol = "[❭](fg:yellow)";
      };

    };
  };
}
