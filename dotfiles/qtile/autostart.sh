#!/usr/bin/env bash

log_dir=$HOME/.local/share/qtile

_log_app() {
  app_name=$(echo "$1" | awk '{ print $1 }')
  time=$(date +"%D %T")

  echo "[autostart] $time: Launch $app_name"
  $1 2>"$log_dir/$app_name.log" || echo "[warning] $" &
}

declare -a programs

programs=(
  "nitrogen --restore"
  "vivaldi"
  "spotify"
  "flatpak run com.spotify.Client"
  "signal-desktop --use-tray-icon --no-sandbox"
  "telegram-desktop"
  "blueman-applet"
)

for app in "${programs[@]}"; do
  _log_app "$app"
done
