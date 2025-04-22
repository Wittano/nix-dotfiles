activate:
	nh os switch -H pc . -- --show-trace

activate-laptop:
	nh os switch -H laptop . -- --show-trace

clean:
ifneq (,$(windcard result))
	unlink result
endif
	nh clean all

check:
	nix flake check
	statix check

xmonad-check:
	PWD=$(pwd)
	cd ./nixos/desktop/xmonad
	cabal build --enable-nix
	cd $PWD

try-laptop:
	nh os build -H laptop . -- --show-trace

build-laptop:
	nh os build -H laptop . -- --show-trace
