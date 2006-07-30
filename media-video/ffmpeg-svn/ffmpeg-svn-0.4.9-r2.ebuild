# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.9_p20060517.ebuild,v 1.1 2006/05/17 09:52:14 lu_zero Exp $

inherit subversion flag-o-matic toolchain-funcs

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
HOMEPAGE="http://ffmpeg.sourceforge.net/"
NBV="540"
WBV="520"
SRC_URI="amr? ( http://www.3gpp.org/ftp/Specs/latest/Rel-5/26_series/26204-${WBV}.zip
			http://www.3gpp.org/ftp/Specs/latest/Rel-5/26_series/26104-${NBV}.zip )"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/ffmpeg/trunk"
#ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac debug doc ieee1394 a52 encode imlib mmx ogg vorbis oss lame
	threads truetype v4l xvid dts network zlib sdl amr x264 static"

DEPEND="imlib? ( media-libs/imlib2 )
	truetype? ( >=media-libs/freetype-2 )
	sdl? ( >=media-libs/libsdl-1.2.10 )
	doc? ( app-text/texi2html )
	lame? ( media-sound/lame )
	ogg? ( media-libs/libogg )
	vorbis? ( media-libs/libvorbis )
	aac? ( media-libs/faad2 media-libs/faac )
	a52? ( >=media-libs/a52dec-0.7.4-r4 )
	xvid? ( >=media-libs/xvid-1.1.0 )
	zlib? ( sys-libs/zlib )
	dts? || ( media-libs/libdca media-libs/libdts )
	ieee1394? ( =media-libs/libdc1394-1*
	            sys-libs/libraw1394 )
	dev-util/pkgconfig
	amr? ( app-arch/unzip )
	x264? ( media-libs/x264 )
	test? ( net-misc/wget )"

src_unpack() {
	subversion_src_unpack

	cd ${WORKDIR}
	if use amr; then
		unpack ${A}
		unzip -jaq 26204-${WBV}_ANSI-C_source_code.zip -d ${S}/libavcodec/amrwb_float
		unzip -jaq 26104-${NBV}_ANSI_C_source_code.zip -d ${S}/libavcodec/amr_float
	fi

	cd ${S}

	REVISION="$(svnversion \
		${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/})"
	sed -i "s:\(svn_revision=\)\`.*:\1${REVISION}:" version.sh

	#Append -fomit-frame-pointer to avoid some common issues
	use debug || append-flags "-fomit-frame-pointer"

	#ffmpeg doesn'g use libtool, so the condition for PIC code
	#is __PIC__, not PIC.
	sed -i -e 's/#\(\(.*def *\)\|\(.*defined *\)\|\(.*defined(*\)\)PIC/#\1__PIC__/' \
		libavcodec/i386/dsputil_mmx{.c,_rnd.h,_avg.h} \
		libavcodec/msmpeg4.c \
		libavutil/common.h \
		|| die "sed failed (__PIC__)"

	# Make it use pic always since we don't need textrels
	use mmx ||
	sed -i -e "s:LIBOBJFLAGS=\"\":LIBOBJFLAGS=\'\$\(PIC\)\':" configure

	sed -i 's:\(logfile="config\)\.err:\1.log:' configure
	# fix lame with --as-needed
	sed -i 's:\( -lmp3lame\):\1 -lm:' configure
	has_version '>=media-libs/faad2-2.1' && \
		sed -i 's:faac\(DecOpen\):NeAAC\1:' configure

	# To make sure the ffserver test will work 
	sed -i -e "s:-e debug=off::" tests/server-regression.sh

	# skip running ldconfig on make install
	sed -i /LDCONFIG/d Makefile
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
	replace-flags -O0 -O2

	local myconf="--log --enable-shared --enable-gpl --enable-pp --disable-opts --disable-strip"

	teh_conf dis debug
	teh_conf en lame mp3lame
	teh_conf en a52
	teh_conf dis oss audio-oss
	teh_conf dis v4l
	teh_conf dis ieee1394 dv1394
	teh_conf en ieee1394 dc1394
	teh_conf en threads pthreads
	teh_conf en xvid
	teh_conf en ogg libogg
	teh_conf en vorbis
	teh_conf en dts
	teh_conf dis network
	teh_conf dis zlib
	teh_conf dis sdl ffplay
	teh_conf en amr amr_nb
	teh_conf en amr amr_wb
	teh_conf en amr amr_if2
	teh_conf en x264 x264
	teh_conf en aac faad
	teh_conf en aac faac

	use encode || myconf="${myconf} --disable-encoders --disable-muxers"

	./configure \
		--prefix=/usr \
		$(use_enable static) \
		${myconf} || die "Configure failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	use doc && make documentation
	make DESTDIR=${D} install || die "Install Failed"

	dodoc Changelog CREDITS README MAINTAINERS doc/*.txt
}

# Never die for now...
src_test() {

	cd ${S}/tests
	for t in "codectest libavtest test-server" ; do
		make ${t} || ewarn "Some tests in ${t} failed"
	done
}

pkg_postinst() {

	ewarn "ffmpeg may had ABI changes, if ffmpeg based programs"
	ewarn "like xine-lib or vlc stop working as expected please"
	ewarn "rebuild them."

}
