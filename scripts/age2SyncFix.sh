#!/bin/bash

STEAM=/mnt/games/steam/steamapps
AGE=$STEAM/compatdata/813780/pfx/drive_c/windows/system32

cd $AGE

if [ ! -e "vc_redist.x64.exe" ]; then
    wget "https://aka.ms/vs/16/release/vc_redist.x64.exe"
fi

sudo cabextract vc_redist.x64.exe
sudo cabextract a10
