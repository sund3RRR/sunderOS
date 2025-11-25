{
  tuxedo-drivers,
  fetchFromGitLab,
}:
tuxedo-drivers.overrideAttrs (
  finalAttrs: prevAttrs: {
    # Add Mechrevo vendor in dmi match to passthrough tuxedo_compatibility_check
    patches = [ ./add_mechrevo_vendor.patch ];

    postPatch = ''
      # Fix makefile
      substituteInPlace Makefile \
        --replace-quiet "cp -r usr /" "true"

      # Fix fan speed bug (frequently switching to 100% speed when not needed)
      substituteInPlace src/tuxedo_io/tuxedo_io.c \
        --replace-fail "!dmi_match(DMI_BOARD_NAME, \"GXxMRXx\")) {" \
          "(!dmi_match(DMI_BOARD_NAME, \"GXxMRXx\") || !dmi_match(DMI_BOARD_NAME, \"GXxHRXx\"))) {"
    '';
  }
)
 