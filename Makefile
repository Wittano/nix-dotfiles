activate:
	nh os switch -H pc . -- --show-trace

clean:
ifeq (,$(windcard result))
	unlink result
endif
	nh clean all

check:
	nix flake check
	statix check
