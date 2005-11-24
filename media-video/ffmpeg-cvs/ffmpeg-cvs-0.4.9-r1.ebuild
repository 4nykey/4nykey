# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.9_p20050906.ebuild,v 1.8 2005/10/06 03:41:04 vapier Exp $

inherit cvs flag-o-matic multilib toolchain-funcs

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
HOMEPAGE="http://ffmpeg.sourceforge.net/"
NBV="540"
WBV="520"
SRC_URI="amr? ( http://www.3gpp.org/ftp/Specs/latest/Rel-5/26_series/26204-${WBV}.zip
			http://www.3gpp.org/ftp/Specs/latest/Rel-5/26_series/26104-${NBV}.zip )"
ECVS_SERVER="mplayerhq.hu:/cvsroot/ffmpeg"
ECVS_MODULE="ffmpeg"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
# ~alpha need to test aac useflag
# ~ia64 ~arm ~mips ~hppa
KEYWORDS="~x86"
IUSE="aac altivec debug doc ieee1394 a52 encode imlib mmx ogg vorbis oss test
	theora threads truetype v4l xvid dts network zlib sdl amr dirac x264 static"

DEPEND="imlib? ( media-libs/imlib2 )
	truetype? ( >=media-libs/freetype-2 )
	sdl? ( >=media-libs/libsdl-1.2.1 )
	doc? ( app-text/texi2html )
	encode? ( media-sound/lame )
	ogg? ( media-libs/libogg )
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )
	aac? ( media-libs/faad2 media-libs/faac )
	a52? ( >=media-libs/a52dec-0.7.4-r4 )
	xvid? ( >=media-libs/xvid-1.0.3 )
	zlib? ( sys-libs/zlib )
	dts? ( media-libs/libdts )
	ieee1394? ( =media-libs/libdc1394-1*
	            sys-libs/libraw1394 )
	dev-util/pkgconfig
	amr? ( app-arch/unzip )
	x264? ( media-libs/x264 )
	dirac? ( >=media-video/dirac-0.5.3 )
	test? ( net-misc/wget )"

src_unpack() {
	cvs_src_unpack

	cd ${WORKDIR}
	if use amr; then
		unpack ${A}
		unzip -jaq 26204-${WBV}_ANSI-C_source_code.zip -d ${S}/libavcodec/amrwb_float
		unzip -jaq 26104-${NBV}_ANSI_C_source_code.zip -d ${S}/libavcodec/amr_float
	fi

	cd ${S}

	#Append -fomit-frame-pointer to avoid some common issues
	use debug || append-flags "-fomit-frame-pointer"

	# for some reason it tries to #include <X11/Xlib.h>, but doesn't use it
	sed -i s:\#define\ HAVE_X11:\#define\ HAVE_LINUX: ffplay.c

	#ffmpeg doesn'g use libtool, so the condition for PIC code
	#is __PIC__, not PIC.
	sed -i -e 's/#\(\(.*def *\)\|\(.*defined *\)\|\(.*defined(*\)\)PIC/#\1__PIC__/' \
		libavcodec/i386/dsputil_mmx{.c,_rnd.h,_avg.h} \
		libavcodec/msmpeg4.c \
		libavutil/common.h \
		|| die "sed failed (__PIC__)"

	# epatch ${FILESDIR}/${PN}-libdir-pic.patch
	# epatch ${FILESDIR}/${PN}-a52.patch
	# epatch ${FILESDIR}/${PN}-missing_links.patch
	# To make sure the ffserver test will work 
	sed -i -e "s:-e debug=off::" tests/server-regression.sh

	# skip running ldconfig on make install
	for dir in libavcodec libavcodec/libpostproc libavformat libavutil
		do sed -i /LDCONFIG/d $dir/Makefile
	done

	epatch ${FILESDIR}/ffmpeg-dirac-patch.txt
}

teh_conf() {
	# configure will boil out on 'unsupported' options, so...
	ACTION="--$1able"
	if [ "$1" == "en" ]; then
		use $2 &&
			myconf="${myconf} ${ACTION}-$( [ -n "$3" ] && echo $3 || echo $2)"
	else
		use $2 ||
			myconf="${myconf} ${ACTION}-$( [ -n "$3" ] && echo $3 || echo $2)"
	fi
}

src_compile() {
	#Note; library makefiles don't propogate flags from config.mak so
	#use specified CFLAGS are only used in executables
	filter-flags -fforce-addr -momit-leaf-frame-pointer

	local myconf="--enable-gpl --enable-pp --enable-shared-pp --disable-opts"

	teh_conf dis debug
	teh_conf en encode mp3lame
	teh_conf en a52
	teh_conf dis oss audio-oss
	teh_conf dis v4l
	teh_conf dis ieee1394 dv1394
	teh_conf en ieee1394 dc1394
	teh_conf en threads pthreads
	teh_conf en xvid
	teh_conf en ogg libogg
	teh_conf en vorbis
	teh_conf en theora
	teh_conf en dts
	teh_conf dis network
	teh_conf dis zlib
	teh_conf dis sdl ffplay
	teh_conf en amr amr_nb
	teh_conf en amr amr_wb
	teh_conf en amr amr_if2
	teh_conf en x264 x264
	teh_conf en dirac
	teh_conf en aac faad
	teh_conf en aac faac

	use static || myconf="${myconf} --enable-shared"
	use encode || myconf="${myconf} --disable-encoders --disable-muxers"
	use dirac || myconf="${myconf} --disable-codec=dirac"

	./configure --prefix=/usr ${myconf} || die "Configure failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	use doc && make documentation
	make DESTDIR=${D} \
		prefix=${D}/usr \
		libdir=${D}/usr/$(get_libdir) \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		bindir=${D}/usr/bin \
		install $(use static && echo installlib) || die "Install Failed"

	dodoc Changelog README INSTALL
	dodoc doc/*

	cd libavcodec/libpostproc
	make prefix=${D}/usr libdir=${D}/usr/$(get_libdir) \
		SHARED_PP="yes" \
		install || die "Failed to install libpostproc.so!"

	# Some stuff like transcode can use this one.
	dolib.a ${S}/libavcodec/libpostproc/libpostproc.a

	preplib /usr
}

# Never die for now...
src_test() {

	for d in ${S_STATIC} ${S_SHARED}; do
		cd ${d}
		make test || ewarn "Some test failed"
	done
}
