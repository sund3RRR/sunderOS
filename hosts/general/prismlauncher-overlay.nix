{
  config,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (finalAttrs: prevAttrs: {
        postPatch = ''
          substituteInPlace launcher/minecraft/auth/MinecraftAccount.h \
            --replace-fail "bool ownsMinecraft() const { return data.type != AccountType::Offline && data.minecraftEntitlement.ownsMinecraft; }" \
              "bool ownsMinecraft() const { return true; }"
          substituteInPlace launcher/ui/pages/global/AccountListPage.cpp \
            --replace-fail "if (!m_accounts->anyAccountIsValid()) {" "if (false) {"
        '';
      });
    })
  ];
}
