check-profile:
ifeq ($(filter $(PROFILE), pc laptop),)
	$(error unknown profile: $(PROFILE))
endif

activate: unlink-qtile check-profile check
	sudo nixos-rebuild switch --flake .#$(PROFILE) || systemctl restart home-manager-$(shell whoami).service

clean:
ifneq (,$(windcard result))
	unlink result
endif
	nh clean all

check: xmonad-check
	statix fix
	nix flake check --show-trace

unlink-qtile:
	unlink $(HOME)/.config/qtile || echo "Missing qtile link"

qtile-test: unlink-qtile
	ln -s $(NIX_DOTFILES)/nixos/desktop/qtile $(HOME)/.config/qtile

qtile-check:
	qtile check -c nixos/desktop/qtile/config.py

restore-home: unlink-qtile
	systemctl restart home-manager-$(shell whoami).service

xmonad-check:
	cabal update
	cd ./nixos/desktop/xmonad && cabal check && cabal build && cabal test

try-build: check-profile check
	nixos-rebuild try-build --flake .#$(PROFILE)

build: check-profile try-build
	nixos-rebuild build --flake .#$(PROFILE)
