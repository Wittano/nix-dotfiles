{ lib, ... }:
let
  isWittanoUserChecker = ''
    if [ "$USER" != "wittano" ]; then
      echo "Invalid user! This script can be used by 'wittano' user"
      exit -1
    fi
  '';

  fileExistFunction = ''
    _file_exist() {
      if [ ! -e $1 ]; then
        echo "File $1 must be exist!"
        exit -1
      fi
    }
  '';

  createMutableLink = src: dest: ''
    #!/bin/sh

    ${fileExistFunction}

    ${isWittanoUserChecker}

    DOTFILES_BACKUP=$HOME/.dotfiles.backup

    # Create .dotfiles.backup directory
    if [ ! -d $DOTFILES_BACKUP ]; then
      mkdir -p $DOTFILES_BACKUP
    fi

    _file_exist ${src}

    if [ ! -L "${dest}" ] && [ -e "${dest}" ]; then
      mv ${dest} $DOTFILES_BACKUP
    fi

    if [ ! -L "${dest}" ]; then
       ln -s ${src} ${dest}
    fi
  '';

  removeMutableLink = dest: ''
    #!/bin/sh

    ${isWittanoUserChecker}

    NIX_STORE_PATH=$(readlink ${dest} | grep '/nix/store' || echo "")

    if [ -L "${dest}" ] && [ -z $NIX_STORE_PATH ]; then
      unlink ${dest} || echo "Warning: File the path: ${dest}, cannot be removed"
    fi
  '';
in
{
  createMutableLinkActivation = cfg: path:
    let
      src = "$DOTFILES/${path}";
      dest = "$HOME/${path}";
      isDevMode = cfg ? enableDevMode && cfg.enableDevMode;
      activationScript =
        if isDevMode then
          createMutableLink src dest
        else
          removeMutableLink dest;
    in
    if isDevMode then
      lib.hm.dag.entryAfter [ "writeBoundary" ] activationScript
    else
      lib.hm.dag.entryBefore [ "checkFilesChanged" ] activationScript;
}
