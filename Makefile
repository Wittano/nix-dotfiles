activate: check
	nh os switch -H pc . -- --show-trace

activate-laptop: check
	nh os switch -H laptop . -- --show-trace

clean:
ifneq (,$(windcard result))
	unlink result
endif
	nh clean all

check: xmonad-check
	statix fix
	nix flake check

xmonad-check:
	cabal update
	cd ./nixos/desktop/xmonad && cabal check && cabal build && cabal test

try-laptop: check
	nh os build -H laptop . -- --show-trace

build-laptop: check
	nh os build -H laptop . -- --show-trace
