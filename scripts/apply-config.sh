#!/bin/bash

DOTFILE_DIR=$HOME/dotfiles

for config in $(ls $DOTFILE_DIR/.config); do
	if [ ! -L $HOME/.config/$config ]; then
		if [ -d $HOME/.config/$config ]; then
			mv $HOME/.config/$config $HOME/.config/$config.old
		fi

		ln -s $DOTFILE_DIR/.config/$config $HOME/.config/$config
	fi
done
themes=(.bg .themes .icons)
for dir in "${themes[@]}"; do
	if [ ! -L $HOME/$dir ]; then
		ln -s $DOTFILE_DIR/$dir $HOME
	fi
done
