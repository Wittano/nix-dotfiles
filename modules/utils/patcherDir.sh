#!/usr/bin/env bash

programs=$(find "$1" -type f -perm /u=x -exec file --mime-type {} \; | grep -E "application/(x-executable)|(x-pie-executable)" | cut -d ':' -f 1)

if [ -z "$programs" ]; then
    echo "Nothing changes"
    exit
fi

for p in $programs; do
    echo "Set new interperter for $p"
    patchelf --set-interpreter "$GLIB_PATH" "$p"
done
