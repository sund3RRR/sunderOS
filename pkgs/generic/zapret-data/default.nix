{
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  version = "1.6.3";
in
stdenvNoCC.mkDerivation {
  name = "zapret-data";
  inherit version;

  src = fetchFromGitHub {
    owner = "Flowseal";
    repo = "zapret-discord-youtube";
    tag = version;
    hash = "sha256-xl6pX9cfSeWEIcmcZOmzLzxrtw9jnI1RkgQDYOBKMhk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/zapret-data
    cp bin/quic_initial_www_google_com.bin $out/share/zapret-data/
    cp bin/tls_clienthello_www_google_com.bin $out/share/zapret-data/
    cp ipset-discord.txt $out/share/zapret-data/
    cp list-discord.txt $out/share/zapret-data/
    cp list-general.txt $out/share/zapret-data/

    runHook postInstall
  '';
}