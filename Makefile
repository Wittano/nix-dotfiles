activate: unlink-qtile check
	NIX_BUILD_CORES=$(shell nproc) sudo nixos-rebuild switch --flake .#$(PROFILE) || systemctl restart home-manager-$(shell whoami).service

clean:
ifneq (,$(windcard result))
	unlink result
endif
	nh clean all

check: xmonad-check
	statix fix
	nix flake check --show-trace --max-jobs $(shell nproc)

qtile_dest_path = $(HOME)/.config/qtile

unlink-qtile:
ifneq ($(wildcard qtile_dest_path),)
	unlink $(qtile_dest_path)
endif

qtile-test: unlink-qtile
	ln -s $(NIX_DOTFILES)/nixos/desktop/qtile $(qtile_dest_path)

openbox_path = $(HOME)/.config/openbox
openbox_source = $(NIX_DOTFILES)/nixos/desktop/openbox

unlink-openbox:
	unlink $(openbox_path)/rc.xml
	unlink $(openbox_path)/menu.xml

openbox-test: unlink-openbox
	ln -s $(openbox_source)/rc.xml $(openbox_path)/rc.xml
	ln -s $(openbox_source)/menu.xml $(openbox_path)/menu.xml

qtile-check:
	qtile check -c nixos/desktop/qtile/config.py

restore-home: unlink-qtile unlink-openbox
	systemctl restart home-manager-$(shell whoami).service

xmonad-check:
	cabal update
	cd ./nixos/desktop/xmonad && cabal check && cabal build && cabal test

try-build: check
	NIX_BUILD_CORES=$(shell nproc) nixos-rebuild try-build --flake .#$(PROFILE)

build: check unlink-openbox
	NIX_BUILD_CORES=$(shell nproc) nixos-rebuild build --flake .#$(PROFILE)
