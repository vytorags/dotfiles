{
  lib,
  hostName ? null,
  role ? "desktop",
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases =
      let
        flakeDir = "~/nixdots";
        host =
          if hostName != null && hostName != "" then
            hostName
          else if role == "desktop" then
            "gh0stk"
          else
            "slime";
      in
      {
        rb = "sudo nixos-rebuild switch --flake ${flakeDir}#${host}";
        upd = "nix flake update ${flakeDir}";
        upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}#${host}";
        # hms = "home-manager switch --flake ${flakeDir}";
        conf = "nvim ${flakeDir}/modules/configuration.nix";
        pkgs = "nvim ${flakeDir}/modules/packages.nix";
        ls = "eza -ha --icons=auto --sort=name --group-directories-first";
        ll = "eza -lh --icons=auto";
        ff = "fastfetch";
        clear = "clear && printf $'\\033c'";
      };

    initContent = ''
      export PATH="$HOME/.cache/npm/global/bin:$HOME/.nix-profile/bin:$PATH"

      KEYTIMEOUT=1
    '';

    oh-my-zsh = {
      enable = true;
      theme = "kphoen";
    };
  };
}
