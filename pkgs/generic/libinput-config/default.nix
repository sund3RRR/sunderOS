{
  fetchFromGitLab,
  stdenv,
  meson,
  ninja,
  pkg-config,
  libinput,
}:
stdenv.mkDerivation {
  pname = "libinput-config";
  version = "unstable-2023-11-23";

  src = fetchFromGitLab {
    owner = "warningnonpotablewater";
    repo = "libinput-config";
    rev = "2bd67e6c829b96c29dc23df28b1ad4191a602122";
    hash = "sha256-JqKlQTJ46NEY+EgZFTubPYV45ey5lfX/giKN0fJblQM=";
  };

  patches = [
    ./meson.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libinput
  ];
}
