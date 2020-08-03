GIMPTOOL ?= gimptool-2.0
CPPFLAGS += -DGIMP_DISABLE_DEPRECATED
CPPFLAGS += $(shell $(GIMPTOOL) --cflags)
LIBS = $(shell $(GIMPTOOL) --libs)
srcs = $(patsubst %.c,%.o,$(wildcard src/*.c src/*/*.c))
%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
bimp: $(srcs)
	$(CC) $(LDFLAGS) -o $@ $? $(LIBS)
