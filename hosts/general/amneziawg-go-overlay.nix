{
  config,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      amneziawg-go = prev.amneziawg-go.overrideAttrs (
        finalAttrs: prevAttrs: {
          name = "amneziawg-go";
          version = "0.2.13";

          src = prev.fetchFromGitHub {
            owner = "amnezia-vpn";
            repo = "amneziawg-go";
            tag = "v${finalAttrs.version}";
            hash = "sha256-vXSPUGBMP37kXJ4Zn5TDLAzG8N+yO/IIj9nSKrZ+sFA=";
          };

          vendorHash = "sha256-9OtIb3UQXpAA0OzPhDIdb9lXZQHHiYCcmjHAU+vCtpk=";
        }
      );
    })
  ];
}
