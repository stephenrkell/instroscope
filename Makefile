THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))

-include $(dir $(THIS_MAKEFILE))/config.mk

export CFLAGS += -std=c11
export CFLAGS += -O3 -fPIC -save-temps -g
export LDFLAGS += -Wl,--export-dynamic
# -Wa,-L

export USE_LD := ld.gold

vpath %.c $(dir $(THIS_MAKEFILE))/programs

%-runnable: %.c
	$(CC) $(CFLAGS) -DRUNNABLE -o "$@" $(LDFLAGS) $(LDLIBS) $+
# never build from .o
%: %.o

.PHONY: default subdirs

tools := $(filter-out show-results.sh,$(filter-out programs,$(wildcard [a-z]*)))
cases := adjust-oneptr call-oneptr deref-oneptr deref-oneptrptr index-oneptr write-oneptr list-loop
exes := $(cases) $(patsubst %,%-runnable,$(cases))

ifeq ($(realpath $(shell pwd)),$(realpath $(dir $(THIS_MAKEFILE))))
default: subdirs
else
default: $(exes)
endif

subdirs:
	for d in $(tools); do \
            if [ -d "$$d" ]; then $(MAKE) -C $$d $(exes); fi; \
        done

subdirs-%:
	for d in $(tools); do \
            if [ -d "$$d" ]; then $(MAKE) -C $$d `echo $*`; fi; \
        done

clean: subdirs-clean
	rm -f -- *.o *.allocstubs.* *.cil.* *.s *.i *.fixuplog *.so *.i.allocs *.i.memacc *.ltrans.out *.res
	find -maxdepth 1 -type f -perm +001 -regex '\./[^\.]*$$' | xargs rm -f

%.so: %.o
	$(CC) -save-temps -shared -o "$@" $(CFLAGS) "$<" $(LDFLAGS) $(LDLIBS)

# FIXME: really want a "tear here" pair of labels
# to allow splitting a function into individual bounds operations
# (stack ops versus adjust/deref ops)
show-%:
	cd $* && for fname in $$( find -type f -perm +001 ); do \
	echo ----------------------------------------------; \
	objdump -Rd "$$fname" | \
	sed -n '/ud2/,/ud2/ p' | tail -n+2 | head -n-1 | \
	sed "s^.*^$${fname}: &^"; done

