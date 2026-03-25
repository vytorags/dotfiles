{
  pkgs,
  lib,
  stdenv,
  fetchurl,
  unzip,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sarasa-mono-sc-nf";
  version = "1.0.35-0";

  src = fetchurl {
    url = "https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts/releases/download/v${finalAttrs.version}/sarasa-mono-sc-nerd-font.zip";
    sha256 = "186bfd4baf75d651c0a41bd01655af6738fba376ec8e011a824fbc1a414d9219";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/sarasa-mono-sc-nf

    cp *.ttf $out/share/fonts/truetype/sarasa-mono-sc-nf/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sarasa Mono SC Nerd Font";
    homepage = "https://github.com/jonz94/Sarasa-Gothic-Nerd-Fonts";
    license = licenses.ofl;
    platforms = platforms.all;
  };
})
