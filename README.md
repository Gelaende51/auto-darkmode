# auto-darkmode

Keeps your KDE Plasma color scheme in sync with the time of day — light while the
sun is up, dark after sunset. The script itself is called `auto-knight-color`, after
the upstream script it is based on.

The script does not schedule anything itself. It reads the `daylight` state that
KWin's Night Light already computes and follows it:

- on start it applies the scheme that matches the current daylight state,
- while running it listens on the session bus for Night Light property changes
  and switches when `daylight` flips.

Only the color scheme is changed (`plasma-apply-colorscheme`), so icons, cursors,
window decorations and the Plasma style are left alone.

## Credits

- **Dmitriy Safiullin** — original author of the script and of the day/night logic
  this repository is based on.
- **terra2o** (14.09.2025) — changed it to swap the color scheme instead of the
  full global theme, so icons, cursors and window decorations are not touched.
- **elypter** (2026-11-11) — this fork: the hardcoded `qdbus-qt6` call was
  replaced by a lookup of `qdbus6` / `qdbus` / `qdbus-qt6`. Where the Qt6 tools
  are packaged under another name, every daylight query failed and the script
  concluded "it is always night", so it only ever applied the dark scheme.
  `LIGHT_SCHEME` / `DARK_SCHEME` can now be overridden from the environment.

## Requirements

- KDE Plasma 6 (KWin)
- Night Light **enabled** in System Settings → Appearance & Style → Night Light
  (it computes and schedules the daylight state)
- `qdbus6`, `qdbus` or `qdbus-qt6`, plus `dbus-monitor` and `plasma-apply-colorscheme`

## Install

```sh
git clone https://github.com/Gelaende51/auto-darkmode.git
cd auto-darkmode
./install.sh
```

This installs the script to `~/.local/bin/auto-knight-color` and an autostart
entry to `~/.config/autostart/auto-knight-color.desktop` (with the absolute path
filled in).

Other schemes, e.g. with `kde-material-you-colors`:

```sh
LIGHT_SCHEME=MaterialYouLight DARK_SCHEME=MaterialYouDark ~/.local/bin/auto-knight-color &
```

## Check that it works

```sh
qdbus6 org.kde.KWin /org/kde/KWin/NightLight org.kde.KWin.NightLight.daylight
# -> true (day) or false (night)
```

Logs of the autostart service:

```sh
journalctl --user -u 'app-auto\x2dknight\x2dcolor@autostart.service' -f
```

If the script never switches, Night Light is the usual suspect: with it disabled
or without a schedule there is no `daylight` change to react to. Compare a manual
run of the script against the value the query above returns.

## Development thread

Debugged and fixed in this T3 Code thread (custom scheme, open it in T3 Code):
`t3-thread://v2/86e4e4f1-981d-4600-a3f4-ffcfdbb68262/3a1ace43-bceb-451b-b2af-ae3dcd998076`

## License

The upstream script as received (header above) declares no license, so none is
asserted here; attribution is kept in the script header and in the credits.
