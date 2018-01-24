export PATH := $(SOFTBOUNDCETS)/softboundcets-llvm-clang34/Debug+Asserts/bin:$(PATH)
export LLVM_GOLD := $(SOFTBOUNDCETS)/softboundcets-llvm-clang34/Debug+Asserts/lib/LLVMgold.so
export USE_LD := ld.gold

CC := clang -fsoftboundcets -flto -fno-vectorize -save-temps -g -fsanitize-blacklist=$(dir $(lastword $(MAKEFILE_LIST)))/blacklist
$(info using blacklist $(lastword $(MAKEFILE_LIST))/blacklist)

CFLAGS += -ffunction-sections # for comparison's sake
LDFLAGS += -fuse-ld=gold -flto -L$(SOFTBOUNDCETS)/softboundcets-lib/lto
LDLIBS += -lsoftboundcets_rt -lm -lrt

# For fairness, LTO the code immediately if we can? no, doesn't work
# -- measure the size of symbol f, instead
#%.o: %.c
#	$(CC) -c $(CFLAGS) "$<" -o "$@".tmp.o
#	ld.gold -O4 \
#-plugin=/usr/local/src/softboundcets-34/softboundcets-llvm-clang34/Debug+Asserts/lib/LLVMgold.so \
#-r -o "$@" "$@".tmp.o -L/usr/local/src/softboundcets-34/softboundcets-lib/lto #-lm -lrt $(LDLIBS)

include ../Makefile
