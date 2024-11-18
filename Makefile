activate:
	nh os switch -H pc .

clean:
ifeq (,$(windcard result))
	unlink result
endif
	nh clean all
