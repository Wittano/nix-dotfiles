#!/usr/bin/env bash

MONITOR_COUNT=$(bspc query -M | wc -l)

TERMINAL_WORKSPACE='^3'
DEV_WORKSPACE="^1"
WEB_BROWSER_WORKSPACE='^2'

if [ "$MONITOR_COUNT" -gt 1 ]; then
  MUSIC_WORKSPACE="^6"
  DISCORD_WORKSPACE='^4'
  PDF_WORKSPACE='^6'
else
  MUSIC_WORKSPACE="^2"
  DISCORD_WORKSPACE='^2'
  PDF_WORKSPACE='^2'
fi

#########
# Rules
#########

# JetBrains
bspc rule -a jetbrains-idea desktop="$DEV_WORKSPACE"
bspc rule -a jetbrains-toolbox desktop="$DEV_WORKSPACE"
bspc rule -a "jetbrains-clion" desktop="$DEV_WORKSPACE"
bspc rule -a "jetbrains-pycharm" desktop="$DEV_WORKSPACE"
bspc rule -a "jetbrains-webstorm" desktop="$DEV_WORKSPACE"

# Dev tools
bspc rule -a Emacs desktop="$DEV_WORKSPACE" state=fullscreen
bspc rule -a Code desktop="$DEV_WORKSPACE"

# Web browsers
bspc rule -a "Chromium" desktop="$WEB_BROWSER_WORKSPACE"
bspc rule -a "qutebrowser" desktop="$WEB_BROWSER_WORKSPACE"
bspc rule -a "Vivaldi-stable" desktop="$WEB_BROWSER_WORKSPACE"
bspc rule -a "Firefox" desktop="$WEB_BROWSER_WORKSPACE"
bspc rule -a "Firefox-esr" desktop="$WEB_BROWSER_WORKSPACE"
bspc rule -a "Tor Browser" desktop="$WEB_BROWSER_WORKSPACE"

# Utils
bspc rule -a thunderbird desktop='^2'
bspc rule -a Thunderbird desktop='^2'

# Music
bspc rule -a "Rhythmbox" desktop="$MUSIC_WORKSPACE"
bspc rule -a Shortwave desktop="$MUSIC_WORKSPACE"
bspc rule -a "de.haeckerfelix.Shortwave" desktop="$MUSIC_WORKSPACE"
bspc rule -a "Spotify" desktop="$MUSIC_WORKSPACE"

# Terminals
bspc rule -a Terminator desktop="$TERMINAL_WORKSPACE"
bspc rule -a kitty desktop="$TERMINAL_WORKSPACE"
bspc rule -a Alacritty desktop="$TERMINAL_WORKSPACE"

# Media
bspc rule -a discord desktop="$DISCORD_WORKSPACE"

# Games
bspc rule -a openttd desktop='^1'
bspc rule -a Steam desktop='^1'
bspc rule -a "lutris" desktop='^1'
bspc rule -a "genshinimpact.exe" desktop='^1'
bspc rule -a "steam_app_39540" desktop='^1' state=fullscreen
bspc rule -a "Paradox Launcher" desktop='^1'
bspc rule -a "Cities.x64" desktop='^1'
bspc rule -a "steam_app_813780" desktop='^1'
bspc rule -a "mb_warband_linux" desktop='^1'
bspc rule -a "hl2_linux" desktop='^1'
bspc rule -a "minecraft-launcher" desktop='^1'
bspc rule -a "Shogun2" desktop='^1'
