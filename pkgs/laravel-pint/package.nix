{
  lib,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pint";
  version = "1.29.0";

  src = fetchurl {
    url = "https://github.com/laravel/pint/releases/download/v${finalAttrs.version}/pint.phar";
    hash = "sha256-4p56FjhMW6rPZE1TQC6WOzIMnsXItK/SDDDMz5rdHHs=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/pint
    chmod +x $out/bin/pint
  '';

  meta = {
    description = "Laravel Pint is an opinionated PHP code style fixer for minimalists. Pint is built on top of PHP-CS-Fixer and makes it simple to ensure that your code style stays clean and consistent.";
    homepage = "https://github.com/laravel/pint";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
