#!/bin/bash

MAIN_HOME=/home/wittano

MUSIC=$MAIN_HOME/Music
POLYBAR=$MAIN_HOME/.config/polybar
BSPWM=($MAIN_HOME/.config/bspwm $MAIN_HOME/.config/sxhkd)
EMACS=($MAIN_HOME/.emacs.d $MAIN_HOME/.doom.d)
BACKUP=$MAIN_HOME/project/bash/backup.sh
STARDEW_VALLEY=$MAIN_HOME/.config/StardewValley
PASSWORD=$MAIN_HOME/.keepass

echo $BACKUP

connected() {
	ping 192.168.10.160 -c 1 > /dev/null
}

multi_config(){
	for user in $(ls /home); do
		if [ $user != "lost+found" ];then
			file=/home/$user/$1
			if [ -e $file ];then
				connected && rsync -a /home/$user/$1 wittanosftp@192.168.10.160:~/$2/$1-$user
			fi
		fi
	done
}

# Music
connected && rsync -a --ignore-existing $MUSIC/* wittanosftp@192.168.10.160:~/Music

# ZSH config
multi_config .zshrc Config/zsh

# Polybar
connected && rsync -a $POLYBAR wittanosftp@192.168.10.160:~/Config

# Vim
multi_config .vimrc Config/vim

# BSPWM
for bspwm in $BSPWM; do
	connected && rsync -a $bspwm wittanosftp@192.168.10.160:~/Config
done

# Emacs
for emacs in $EMACS; do
	connected && rsync -a $emacs wittanosftp@192.168.10.160:~/Config/emacs
done

# Backup script
connected && rsync -a $BACKUP wittanosftp@192.168.10.160:~/Config

# Stardew Valley
connected && rsync -a $STARDEW_VALLEY wittanosftp@192.168.10.160:~/Games

# Passwords
connected && rsync -a $PASSWORD wittanosftp@192.168.10.160:~/Keepass
