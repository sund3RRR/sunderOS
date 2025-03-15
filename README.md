# sunderOS

## Change 'monitor-brightness-volume' gnome extension hotkeys
```bash
GSETTINGS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/monitor-brightness-volume@ailin.nemui/schemas::::: gsettings set org.gnome.shell.extensions.monitor-brightness-volume monitor-screen-brightness-up "['XF86MonBrightnessUp']"
GSETTINGS_SCHEMA_DIR=$HOME/.local/share/gnome-shell/extensions/monitor-brightness-volume@ailin.nemui/schemas::::: gsettings set org.gnome.shell.extensions.monitor-brightness-volume monitor-screen-brightness-down "['XF86MonBrightnessDown']"
```