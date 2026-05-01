{
  pkgs,
  unstable,
  mynvim,
  role ? "desktop",
  isDesktop,
  ...
}:
{
  extraPackages =
    with pkgs;
    [
      mynvim.packages.${stdenv.hostPlatform.system}.nvim
      fd
      jq
      ripgrep
      nodejs
      shellcheck
      nixd
      nil
      bash-language-server
      nixfmt-rfc-style
      gnumake
      shfmt
      lazygit
      dbeaver-bin
    ]
    ++ pkgs.lib.optionals isDesktop [
      godot-mono
      vscode-fhs
      unstable.gemini-cli
      unstable.github-copilot-cli
      unstable.antigravity
      (callPackage ../pkgs/opencode/package.nix { })
      # unstable.opencode
      insomnia
      delta
      lazydocker
      emmet-ls
      lua-language-server
      stylua
      nodePackages.prettier
      pnpm
      (callPackage ../pkgs/php-cs-fixer/package.nix { })
      (callPackage ../pkgs/laravel-pint/package.nix { })
      clang-tools
      gcc
    ];

  devShells = {
    php = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        php
        php.packages.composer
        laravel
        nodePackages.intelephense
        (callPackage ../pkgs/php-cs-fixer/package.nix { })
        tailwindcss-language-server
        vtsls
        nodePackages.vscode-langservers-extracted
        nodePackages.eslint
        phpactor
        php.packages.php-codesniffer
        nodePackages.browser-sync
      ];
    };

    go = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        go
        unstable.gopls
        libwebp
      ];
    };

    rust = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        cargo
        rustc
        rust-analyzer
        clippy
        rustfmt
        pkg-config
        openssl
      ];
    };

    node = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        nodejs
        bun
        vtsls
        nodePackages.vscode-langservers-extracted
        nodePackages.eslint_d
        unstable.vue-language-server
        tailwindcss-language-server
      ];
    };

    python = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        python313
        black
        pyright
        python313Packages.tkinter
      ];
    };

    java = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        openjdk21
        jdt-language-server
        maven
        gradle
      ];
    };

    csharp = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        roslyn-ls
        dotnet-sdk_8
        dotnet-aspnetcore_8
        netcoredbg
      ];
    };

    C = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [
        stdenv.cc
        clang-tools
        cmake
        pkg-config
        gnumake
      ];

      buildInputs = with pkgs; [
        glibc.dev
        readline
        editline
      ];

      shellHook = ''
        export C_INCLUDE_PATH="${pkgs.glibc.dev}/include:$C_INCLUDE_PATH"
        export CPLUS_INCLUDE_PATH="${pkgs.glibc.dev}/include:$CPLUS_INCLUDE_PATH"
      '';
    };

    flutter = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        flutter
        android-tools
        jdk21
      ];
    };

    qml = pkgs.mkShellNoCC {
      buildInputs = with pkgs; [
        quickshell
        alejandra
        statix
        deadnix
        shfmt
        shellcheck
        jsonfmt
        lefthook
        kdePackages.qtdeclarative
      ];
    };
  };
}
