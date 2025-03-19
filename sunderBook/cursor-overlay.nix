{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      code-cursor = (
        let
          appimageContents = prev.appimageTools.extractType2 {
            inherit (prev.code-cursor) version pname;
            src = prev.code-cursor.sources.${config.nixpkgs.hostPlatform.system};
            postExtract = ''
              find $out -type f -name '*.js' \
                -exec grep -l ,minHeight {} \; \
                -exec sed -i 's/,minHeight/,frame:false,minHeight/g' {} \;
            '';
          };
        in
        prev.appimageTools.wrapAppImage {
          inherit (prev.code-cursor) pname version;
          src = appimageContents;

          nativeBuildInputs = [ prev.makeWrapper ];

          extraInstallCommands = ''
            mkdir -p $out/share/cursor $out/share/applications/
            cp -a ${appimageContents}/locales $out/share/cursor
            cp -a ${appimageContents}/usr/share/icons $out/share/
            install -Dm 644 ${appimageContents}/cursor.desktop -t $out/share/applications/

            substituteInPlace $out/share/applications/cursor.desktop --replace-fail "AppRun" "cursor"

            wrapProgram $out/bin/cursor \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"
          '';

          passthru = prev.code-cursor.passthru;
        }
      );
    })
  ];
}
