#!/usr/share/env bash

if [ -z `which xsetwacom` ]; then
    echo "Wacom driver isn't installed!"
    exit -1;
fi

tablet=`xsetwacom list devices | awk '{print $9}'`

for i in $tablet; do
    xsetwacom --set "${i}" MapToOutput HEAD-0
done