#!/usr/bin/env bash

muted=$(amixer get Master | tail -n1 | sed -E 's/.*\[([a-z]+)\]/\1/')
volume=$(amixer get Master | tail -n1 | sed -E 's/.*\[([0-9]+)\%\].*/\1/')

if [[ $muted == "off" ]]; then
	echo "Muted"
else
	echo "${volume}%"
fi
