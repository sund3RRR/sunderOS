# sunderOS

## Change 'monitor-brightness-volume' gnome extension hotkeys
```bash
GSETTINGS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/monitor-brightness-volume@ailin.nemui/schemas::::: gsettings set org.gnome.shell.extensions.monitor-brightness-volume monitor-screen-brightness-up "['XF86MonBrightnessUp']"

GSETTINGS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/monitor-brightness-volume@ailin.nemui/schemas::::: gsettings set org.gnome.shell.extensions.monitor-brightness-volume monitor-screen-brightness-down "['XF86MonBrightnessDown']"
```

## Zen Browser config
1) Back to normal NewTab behavior 
```
zen.urlbar.replace-newtab -> true
```
2) Touchpad sensitivity settings
```
apz.gtk.pangesture.page_delta_mode_multiplier -> 0.25
widget.swipe.page-size -> 5.0
```
3) Video decoding
```
gfx.webrender.all -> true
gfx.webrender.compositor -> true
media.hardware-video-decoding.force-enabled -> true
```

## Disable 'sleep' and 'airplane' media buttons on keyboard
```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys suspend-static "['']"
gsettings set org.gnome.settings-daemon.plugins.media-keys rfkill-static "['']"
```