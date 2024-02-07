#!/usr/bin/env bash

log_dir=$HOME/.local/share/bspwm

mkdir -p $log_dir

_log() {
  app_name=$(echo "$1" | awk '{ print $1 }')
  time=$(date +"%D %T")

  echo "[autostart] $time: Launch $app_name" >> $log_dir/$app_name.log
  $1 2>"$log_dir/$app_name.log" || echo "[warning] $app_name has some problem, during autostart!" &
}

touch /tmp/bspwm.autostart.lock

_log "nitrogen --restore"
_log "vivaldi"
_log "spotify"