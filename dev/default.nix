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
      vscode-fhs
      mynvim.packages.${stdenv.hostPlatform.system}.nvim
      gh
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
    ]
    ++ pkgs.lib.optionals isDesktop [
      godot-mono
      unstable.gemini-cli
      insomnia
      delta
      lazydocker
      emmet-ls
      lua-language-server
      stylua
      nodePackages.prettier
      clang-tools
      gcc
    ] ++ pkgs.lib.optionals (!isDesktop) [
      unstable.antigravity-fhs
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
