#!/usr/bin/env bash
set -euo pipefail

REPO=/home/wittano/git/adblock-list
DEST=/etc/hosts

for file in $(ls $REPO/*.txt); do
    cat $file >> $DEST
done
