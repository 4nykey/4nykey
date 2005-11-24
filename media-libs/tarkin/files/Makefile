# use 16 bit signed integers as wavelet coefficients
CFLAGS+= -DTYPE=int16_t

# we'll actually use TYPE_BITS bits of type (e.g. 9 magnitude + 1 sign)
CFLAGS+= -DTYPE_BITS=10

# use the rle entropy coder
CFLAGS+= -DRLECODER

# simple malloc debugging
#CFLAGS+= -DDBG_MEMLEAKS

# dump a lot debug images
#CFLAGS+= -DDBG_XFORM

# dump ogg packet infos
#CFLAGS+= -DDBG_OGG

# disable assertions
CFLAGS+= -DNDEBUG

LIBS = -L. -ltarkin -L/usr/lib -logg

TARGET=libtarkin.a

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

SRCS= \
	info.c \
	mem.c \
	pnm.c \
	tarkin.c \
	wavelet.c \
	wavelet_coeff.c \
	wavelet_xform.c \
	yuv.c

OBJS=$(SRCS:.c=.o)

all: $(TARGET) tarkin_enc tarkin_dec tarkin_sdl_player

$(TARGET): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)
	$(RANLIB) $@

tarkin_enc: $(TARGET) tarkin_enc.o
	$(CC) $(LDFLAGS) tarkin_enc.o -o $@ $(LIBS)

tarkin_dec: $(TARGET) tarkin_dec.o
	$(CC) $(LDFLAGS) tarkin_dec.o -o $@ $(LIBS)

tarkin_sdl_player: $(TARGET) tarkin_sdl_player.o
	$(CC) $(LDFLAGS) `sdl-config --libs` tarkin_sdl_player.o -o $@ $(LIBS)

tarkin_sdl_player.o: tarkin_sdl_player.c
	$(CC) $(CFLAGS) `sdl-config --cflags` -c $< -o $@

