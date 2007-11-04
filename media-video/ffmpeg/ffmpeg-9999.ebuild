# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.9_p20060517.ebuild,v 1.1 2006/05/17 09:52:14 lu_zero Exp $

inherit subversion flag-o-matic toolchain-funcs

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
HOMEPAGE="http://ffmpeg.sourceforge.net/"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/ffmpeg/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
aac debug doc ieee1394 a52 encode imlib mmx ogg vorbis oss threads truetype
v4l v4l2 xvid network zlib X amr x264 static mp3 swscaler sdl
"

RDEPEND="
	imlib? ( media-libs/imlib2 )
	truetype? ( >=media-libs/freetype-2 )
	sdl? ( >=media-libs/libsdl-1.2.10 )
	mp3? ( encode? ( media-sound/lame ) )
	ogg? ( media-libs/libogg )
	vorbis? ( media-libs/libvorbis )
	aac? ( media-libs/faad2 )
	a52? ( >=media-libs/a52dec-0.7.4-r4 )
	zlib? ( sys-libs/zlib )
	ieee1394? (
		=media-libs/libdc1394-1*
		sys-libs/libraw1394
	)
	encode? (
		aac? ( media-libs/faac )
		xvid? ( >=media-libs/xvid-1.1.0 )
		x264? ( media-libs/x264 )
	)
	X? ( x11-libs/libXext )
	amr? ( media-libs/amrnb media-libs/amrwb )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	dev-util/pkgconfig
	doc? ( app-text/texi2html )
	test? ( net-misc/wget )
	X? ( x11-proto/xextproto )
	v4l? ( virtual/os-headers )
	v4l2? ( virtual/os-headers )
"

pkg_setup() {
	# guessing our target
	for x in arch tune cpu; do
		if [[ -z ${_cpu} ]]; then _cpu="$(get-flag -m$x | cut -d= -f2)"
		else break
		fi
	done
	if [[ -z ${_cpu} ]]; then
		_chost="${CTARGET:-${CHOST}}"
		_cpu="${_chost%%-*}"
	fi

	#Append -fomit-frame-pointer to avoid some common issues
	append-flags "-fomit-frame-pointer"
	append-flags -fno-strict-aliasing
	#Note; library makefiles don't propogate flags from config.mak so
	#use specified CFLAGS are only used in executables
	replace-flags -O0 -O2
}

teh_conf() {
	ACTION="--${1}able"
	if [[ $1 == "en" ]]; then
		use $2 && myconf="${myconf} ${ACTION}-${3:-${2}}"
	else
		use $2 || myconf="${myconf} ${ACTION}-${3:-${2}}"
	fi
}

src_compile() {
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	local myconf="--log=config.log --enable-shared --enable-gpl --enable-pp"
	myconf="${myconf} --disable-optimizations --disable-strip"

	teh_conf dis debug
	if use encode; then
		teh_conf en mp3 libmp3lame
		teh_conf en xvid
		teh_conf en x264
		teh_conf en aac libfaac
	fi
	teh_conf en a52 liba52
	teh_conf dis oss audio-oss
	teh_conf dis v4l
	teh_conf dis v4l2
	teh_conf en ieee1394 dc1394
	teh_conf en threads pthreads
	teh_conf en ogg libogg
	teh_conf en vorbis libvorbis
	teh_conf dis network
	teh_conf dis zlib
	teh_conf en amr libamr-nb
	teh_conf en amr libamr-wb
	teh_conf en aac libfaad
	teh_conf en swscaler
	teh_conf en X x11grab
	use sdl && teh_conf dis X ffplay

	use encode || myconf="${myconf} --disable-encoders --disable-muxers"

	./configure \
		--prefix=/usr \
		--cpu="${_cpu:-generic}" \
		$(use_enable static) \
		${myconf} || die "Configure failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	use doc && make documentation
	make DESTDIR=${D} LDCONFIG=/bin/true install || die "Install Failed"

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
