#!/usr/bin/env bash

NITROGEN_CONFIG=$HOME/.config/nitrogen
TINT2_CONFIG=$HOME/.config/tint2

DOTFILE_NITROGEN=$DOTFILES_DIR/.config/nitrogen
DOTFILE_TINT2=$DOTFILES_DIR/.config/tint2

function link_config() {
    if [ -d $2 ]; then
        if [ -L $2 ]; then
            rm $2
        else
            if [ -d $2 ]; then
                mv $2 "$2.backup"
            fi
        fi

        ln -s $1 $2
    fi
}

link_config $DOTFILE_NITROGEN $NITROGEN_CONFIG
link_config $DOTFILE_TINT2 $TINT2_CONFIG
