{
  stdenvNoCC,
  lib,
  writeTextDir,
  background ? "sierra-5120x2880",
}:
let
  wallpapers = stdenvNoCC.mkDerivation {
    name = "wallpapers";
    src = ./src;
    installPhase = ''
      mkdir -p $out/share/wallpapers
      cp * $out/share/wallpapers/
    '';
  };
in
assert (
  lib.asserts.assertOneOf "background" background [
    "nevada-5120x2880"
    "sierra-5120x2880"
  ]
);
(writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
  [General]
  background=${wallpapers}/share/wallpapers/${background}.jpg
'')
