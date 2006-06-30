#
# Makefile for mppdec/mppenc for gcc
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

include version
MAKEFILE = Makefile
# DEBIAN DESTDIR
DESTDIR = $(pwd)/debian/musepack-encoder/

CC_MAJ = $(shell $(CC) -dumpversion | cut -d. -f1)
CC_MIN = $(shell $(CC) -dumpversion | cut -d. -f2)
MF = $(shell [ $(CC_MAJ)$(CC_MIN) -ge 30 ] && echo f || echo m)
#TUNE = $(shell [ $(CC_MAJ)$(CC_MIN) -ge 34 ] && echo tune || echo cpu)

# Build options
#BLD_STATIC = 1
#MINGW = 1
USE_ASM = 1
#USE_ESD = 1
#USE_OSS = 1

# Compiler flags
WARN = #\
	-Wall \
	-pedantic \
	-W \
	-Wshadow \
	-Wbad-function-cast \
	-Wcast-align \
	-Wwrite-strings \
	-Wconversion \
	-Wsign-compare \
	-Wstrict-prototypes \
	-Wmissing-prototypes \
	-Wmissing-declarations \
	-Wnested-externs \
	-Wno-long-long \

OPTIMIZE = -O2

FLAGS = \
	$(OPTIMIZE) \
	$(CFLAGS) \
	-fomit-frame-pointer \
	-mno-ieee-fp \
	-ffast-math \
	-$(MF)align-jumps=5 \
	-$(MF)align-loops=0 \
	-$(MF)align-functions=5 \
	-pipe \

ifneq ($(CC_MAJ),4)
FLAGS += -fmove-all-movables
endif
ifneq ($(CC_MAJ),2)
# unset optimizations that tend to break mppenc encodings
FLAGS += \
	-fno-strict-aliasing \
	-fno-gcse \
	-fno-finite-math-only \
	-fno-unsafe-math-optimizations
endif

# Some remaining possible options (time measurement and debugging)
#PROFILE = -DPROFILE
#DEBUG = -DNDEBUG

FLAGS += \
	$(FEATURE) \
	$(WARN) \
	$(PROFILE) \
	$(DEBUG) \
	-DMPPDEC_VERSION=\"$(MPPDEC_VERSION)\" \
	-DMPPENC_VERSION=\"$(MPPENC_VERSION)\" \

ifdef USE_ASM
	NASM = nasm
	#NASMFLAGS += -DUSE_FXCH
	FLAGS += -DUSE_ASM
endif

ifdef MINGW
EXEEXT = .exe
LDADD = -lwinmm -lws2_32
NASMFLAGS = -f win32
else
LDADD = -lm
NASMFLAGS = -f elf
# These two already defined in mppenc.h for win32
FEATURE += -DCVD_FASTLOG
FEATURE += -DFAST_MATH
endif

ifdef BLD_STATIC
	LDFLAGS += -static
endif

ifdef USE_ESD
	FLAGS += -DUSE_ESD_AUDIO
	LDADD += $(shell esd-config --libs)
endif

ifdef USE_OSS
	FLAGS += -DUSE_OSS_AUDIO
else
	FLAGS += -DNO_DEV_AUDIO
endif

COMMON_SRC = \
	huffsv7.c \
	profile.c \
	stderr.c \
	tools.c \

MPPDEC_SRC = \
	$(COMMON_SRC) \
	decode.c \
	http.c \
	huffsv46.c \
	id3tag.c \
	mppdec.c \
	requant.c \
	synth.c \
	synthtab.c \
	wave_out.c \
	_setargv.c \

MPPENC_SRC = \
	$(COMMON_SRC) \
	analy_filter.c \
	ans.c \
	bitstream.c \
	cvd.c \
	fft4g.c \
	fft_routines.c \
	mppenc.c \
	psy.c \
	psy_tab.c \
	quant.c \
	encode_sv7.c \
	wave_in.c \
	tags.c \
	fastmath.c \
	pipeopen.c \
	regress.c \
	keyboard.c \

REPLAY_SRC = \
	replaygain.c \
	gain_analysis.c \
	pipeopen.c \
	stderr.c \
	_setargv.c \

ifdef USE_ASM
	ASM_ENC_SRC = fft4gasm.o
	ASM_DEC_SRC = synthasm.o cpu_feat.o
endif

ifdef MINGW
MPPENC_SRC += winmsg.c
endif

ASM_ENC_OBJ = $(ASM_ENC_SRC:.nas=.o)
ASM_DEC_OBJ = $(ASM_DEC_SRC:.nas=.o)
MPPENC_OBJ = $(MPPENC_SRC:.c=_enc.o)
MPPDEC_OBJ = $(MPPDEC_SRC:.c=_dec.o)
REPLAY_OBJ = $(REPLAY_SRC:.c=_dec.o)

# Targets and general dependencies
MPPDEC_TARGET = mppdec$(EXEEXT)
MPPENC_TARGET = mppenc$(EXEEXT)
#STREAM_TARGET = streamserver$(EXEEXT)
REPLAY_TARGET = replaygain$(EXEEXT)
#CLIPSTAT_TARGET = clipstat$(EXEEXT)
#TAGGER_TARGET = tagger$(EXEEXT)
ALL_TARGETS = $(MPPENC_TARGET) $(MPPDEC_TARGET) $(REPLAY_TARGET)

DEPENDS_ASM = $(MAKEFILE) tools.inc version
DEPENDS_DEC = $(MAKEFILE) mppdec.h mpp.h config.h profile.h version
DEPENDS_ENC = $(DEPENDS_DEC) mppenc.h minimax.h

%_enc.o: %.c $(DEPENDS_ENC)
	$(CC) -c $(FLAGS) -DMPP_ENCODER -o $@ $<

%_dec.o: %.c $(DEPENDS_DEC)
	$(CC) -c $(FLAGS) -DMPP_DECODER -o $@ $<

%.o: %.nas $(DEPENDS_ASM)
	$(NASM) $(NASMFLAGS) $< -o $@ -l $(patsubst %.lst,%.nas,$@)

all:	$(ALL_TARGETS)

$(MPPENC_TARGET): $(MPPENC_OBJ) $(ASM_ENC_OBJ)
	$(CC) $(FLAGS) $(LDFLAGS) -o $@ $^ $(LDADD)

$(MPPDEC_TARGET): $(MPPDEC_OBJ) $(ASM_DEC_OBJ)
	$(CC) $(FLAGS) $(LDFLAGS) -o $@ $^ $(LDADD)

$(REPLAY_TARGET): $(REPLAY_OBJ)
	$(CC) $(FLAGS) $(LDFLAGS) -o $@ $(REPLAY_OBJ) $(LDADD)

clean:
	$(RM) $(MPPENC_OBJ) $(MPPDEC_OBJ) $(ASM_ENC_OBJ) $(ASM_DEC_OBJ) $(REPLAY_OBJ) $(MPPENC_TARGET) $(MPPDEC_TARGET) $(REPLAY_TARGET) *.lst
