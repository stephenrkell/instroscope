THIS_MAKEFILE := $(lastword $(MAKEFILE_LIST))

-include $(dir $(THIS_MAKEFILE))/config.mk

export CFLAGS += -O3 -fPIC -save-temps
export LDFLAGS += -Wl,--export-dynamic
# -Wa,-L

export USE_LD := ld.gold

vpath %.c $(dir $(THIS_MAKEFILE))/programs

.PHONY: default subdirs

ifeq ($(realpath $(shell pwd)),$(realpath $(dir $(THIS_MAKEFILE))))
default: subdirs
else
default: adjust-oneptr call-oneptr deref-oneptr deref-oneptrptr index-oneptr write-oneptr
endif

subdirs:
	for d in $(filter-out show-results.sh,$(filter-out Makefile,$(filter-out programs,$(wildcard *)))); do \
            if [ -d "$$d" ]; then $(MAKE) -C $$d; fi; \
        done

subdirs-%:
	for d in $(filter-out show-results.sh,$(filter-out Makefile,$(filter-out programs,$(wildcard *)))); do \
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

