# Makefile - aacgain.dsp

INCLUDES=-I/usr/include -I../mp3gain -I../mpeg4ip/lib/mp4v2 -I../faad2/libfaad -W -DHAVE_STDINT_H -DHAVE_MEMCPY
CFLAGS+=$(INCLUDES)
CXXFLAGS+=$(INCLUDES)
LD=$(CXX) $(CXXFLAGS)
TARGET=aacgain
LIBS=-lfaad -lmp4v2

.PHONY: all
all: $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ -c $<

SOURCE_FILES= \
	../mp3gain/mp3gain.c \
	../mp3gain/apetag.c \
	../mp3gain/mpglibDBL/common.c \
	../mp3gain/mpglibDBL/dct64_i386.c \
	../mp3gain/mpglibDBL/decode_i386.c \
	../mp3gain/gain_analysis.c \
	../mp3gain/mpglibDBL/interface.c \
	../mp3gain/mpglibDBL/layer1.c \
	../mp3gain/mpglibDBL/layer2.c \
	../mp3gain/mpglibDBL/layer3.c \
	../mp3gain/rg_error.c \
	../mp3gain/mpglibDBL/tabinit.c \
	aacgain.cpp \
	decoder.c \
	MP4MetaFile.cpp \
	syntax.c

SRCS=$(SOURCE_FILES)

OBJS=$(patsubst %.rc,%.res,$(patsubst %.cxx,%.o,$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(filter %.c %.cc %.cpp %.cxx %.rc,$(SRCS)))))))

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

.PHONY: clean
clean:
	-rm -f $(OBJS) $(TARGET) aacgain.dep

