activate: check
	nh os switch --no-nom -H pc . -- --show-trace

activate-laptop: check
	nh os switch --no-nom -H laptop . -- --show-trace

clean:
ifneq (,$(windcard result))
	unlink result
endif
	nh clean all

check: xmonad-check
	statix fix
	nix flake check --show-trace

xmonad-check:
	cabal update
	cd ./nixos/desktop/xmonad && cabal check && cabal build && cabal test

try-laptop: check
	nh os build --no-nom -H laptop . -- --show-trace

build-pc: check
	nh os build --no-nom -H pc . -- --show-trace

build-laptop: check
	nh os build --no-nom -H laptop . -- --show-trace
