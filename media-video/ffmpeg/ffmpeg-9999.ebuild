# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/ffmpeg/ffmpeg-0.4.9_p20060517.ebuild,v 1.1 2006/05/17 09:52:14 lu_zero Exp $

inherit subversion flag-o-matic toolchain-funcs confutils

DESCRIPTION="Complete solution to record, convert and stream audio and video. Includes libavcodec."
HOMEPAGE="http://ffmpeg.sourceforge.net/"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/ffmpeg/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
aac debug doc ieee1394 a52 encode imlib mmx vorbis oss threads truetype v4l
v4l2 xvid network zlib X amr x264 static mp3 swscaler sdl bindist postproc
"

RDEPEND="
	imlib? ( media-libs/imlib2 )
	truetype? ( >=media-libs/freetype-2 )
	sdl? ( >=media-libs/libsdl-1.2.10 )
	mp3? ( encode? ( media-sound/lame ) )
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

	confutils_use_conflict amr bindist
}

src_compile() {
	local my_conf="--logfile=config.log --enable-shared --enable-gpl"
	my_conf="${my_conf} --disable-optimizations --disable-stripping"

	enable_extension_disable debug debug
	if use encode; then
		enable_extension_enableonly libmp3lame mp3
		enable_extension_enableonly libxvid xvid
		enable_extension_enableonly libx264 x264
		enable_extension_enableonly libfaac aac
	else
		my_conf="${my_conf} --disable-encoders --disable-muxers"
	fi
	enable_extension_enableonly liba52 a52
	enable_extension_disable demuxer=oss oss
	enable_extension_disable muxer=oss oss
	enable_extension_disable demuxer=v4l v4l
	enable_extension_disable demuxer=v4l2 v4l2
	enable_extension_enableonly libdc1394 ieee1394
	enable_extension_enableonly pthreads threads
	enable_extension_enableonly libvorbis vorbis
	enable_extension_disable network network
	enable_extension_disable zlib zlib
	use amr && my_conf="${my_conf} --enable-nonfree"
	enable_extension_enableonly libamr-nb amr
	enable_extension_enableonly libamr-wb amr
	enable_extension_enableonly libfaad aac
	enable_extension_enableonly postproc postproc
	enable_extension_enableonly swscale swscaler
	enable_extension_enableonly x11grab X
	use sdl && enable_extension_disable ffplay X

	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--shlibdir=/usr/$(get_libdir) \
		--incdir=/usr/include \
		--mandir=/usr/share/man \
		--cpu="${_cpu:-generic}" \
		$(use_enable static) \
		${my_conf} || die "Configure failed"

	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	use doc && emake documentation
	emake DESTDIR=${D} LDCONFIG=/bin/true install || die "Install Failed"
	dodoc Changelog CREDITS README MAINTAINERS doc/*.txt

	dodir /usr/include/{ffmpeg,postproc}
	cd "${D}"usr/include/ffmpeg
	find .. -type f -name \*.h | while read h; do ln -s ${h}; done
	mv postprocess.h ../postproc
}

# Never die for now...
src_test() {

	cd ${S}/tests
	for t in "codectest libavtest test-server" ; do
		emake ${t} || ewarn "Some tests in ${t} failed"
	done
}

pkg_postinst() {

	ewarn "ffmpeg may had ABI changes, if ffmpeg based programs"
	ewarn "like xine-lib or vlc stop working as expected please"
	ewarn "rebuild them."

}
