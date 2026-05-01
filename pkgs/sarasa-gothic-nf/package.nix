{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  unzip,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sarasa-mono-tc-nf";
  version = "1.0.37-0";

  src = fetchurl {
    url = "https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts/releases/download/v${finalAttrs.version}/sarasa-mono-tc-nerd-font.zip";
    sha256 = "sha256-swu7BkQ13P6nth6cqZVquDA1lD8FNIHhvpFvAJCcIg4=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/sarasa-mono-tc-nf

    cp *.ttf $out/share/fonts/truetype/sarasa-mono-tc-nf/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sarasa Mono TC Nerd Font";
    homepage = "https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts";
    license = licenses.ofl;
    platforms = platforms.all;
  };
})
