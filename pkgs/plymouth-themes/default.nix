{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  theme ? "glowing",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plymouth-themes";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3lRgIBzDkKcWEp5yyRCzQJM6yyTjYC5XmNUZZroDuw=";
  };

  dontBuild = true;

  postPatch = ''
    mkdir themes
    for dir in pack_*; do
      if [ -d "$dir" ]; then
        cp -r "$dir"/* themes/
      fi
    done

    for theme in themes/*; do
      if [ -d "''$theme" ]; then
        substituteInPlace "''$theme/''${theme##*/}.plymouth" \
          --replace-fail "ImageDir=/usr/share/plymouth/themes/" "ImageDir=$out/share/plymouth/themes/" \
          --replace-fail "ScriptFile=/usr/share/plymouth/themes/" "ScriptFile=$out/share/plymouth/themes/"
      fi
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes
    cp -r themes/${theme} $out/share/plymouth/themes/

    runHook postInstall
  '';
})