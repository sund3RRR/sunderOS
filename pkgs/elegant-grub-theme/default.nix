{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  theme ? "forest",
  type ? "window",
  side ? "left",
  color ? "dark",
  resolution ? "1080p",
  logo ? "Nixos",
}:
assert (
  (lib.asserts.assertOneOf "theme" theme [
    "forest"
    "mojave"
    "mountain"
    "wave"
  ])
  && (lib.asserts.assertOneOf "type" type [
    "window"
    "float"
    "sharp"
    "blur"
  ])
  && (lib.asserts.assertOneOf "side" side [
    "left"
    "right"
  ])
  && (lib.asserts.assertOneOf "color" color [
    "light"
    "dark"
  ])
  && (lib.asserts.assertOneOf "resolution" resolution [
    "1080p"
    "2k"
    "4k"
  ])
);
stdenvNoCC.mkDerivation {
  name = "elegant-grub-theme";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Elegant-grub2-themes";
    tag = "2024-11-03";
    hash = "sha256-GSI5nRR9vTBnnjZSlj6KrYUHencLdd4e+ROe6xb9qxs=";
  };

  installPhase = ''
    mkdir -p $out/icons

    if [[ "${type}" == "blur" ]]; then
      suffix="white"
    else
      suffix="${theme}-${color}"
    fi
    cp assets/assets-other/other-${resolution}/select_e-''${suffix}.png $out/select_e.png
    cp assets/assets-other/other-${resolution}/select_c-''${suffix}.png $out/select_c.png
    cp assets/assets-other/other-${resolution}/select_w-''${suffix}.png $out/select_w.png

    info_file="assets/assets-other/other-${resolution}/${type}-${side}"
    if [[ "${theme}" == "forest" ]]; then
      info_file="assets/assets-other/other-${resolution}/${type}-${side}-alt"
      [[ "${type}" == "blur" ]] && info_file="sharp-${side}-alt"
    else
      [[ "${type}" == "blur" ]] && info_file="sharp-${side}"
    fi
    cp "''${info_file}.png" "$out/info.png"

    cp -r assets/assets-icons-${color}/icons-${color}-${resolution}/* $out/icons/
    cp assets/assets-other/other-${resolution}/${logo}.png $out/logo.png
    cp backgrounds/backgrounds-${theme}/background-${theme}-${type}-${side}-${color}.jpg $out/background.jpg
    cp common/*.pf2 $out/
    cp common/*.otf $out/
    cp config/theme-${type}-${side}-${color}-${resolution}.txt $out/theme.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/AdisonCavani/distro-grub-themes";
    description = "An Elegant GRUB2 themes";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sund3RRR ];
    platforms = platforms.linux;
  };
}
