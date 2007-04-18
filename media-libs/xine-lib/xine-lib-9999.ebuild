# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xine-lib/xine-lib-1.1.4-r1.ebuild,v 1.1 2007/02/09 04:46:07 flameeyes Exp $

inherit mercurial flag-o-matic toolchain-funcs libtool autotools

DESCRIPTION="Core libraries for Xine movie player"
HOMEPAGE="http://xine.sourceforge.net/"
EHG_REPO_URI="http://hg.debian.org/hg/xine-lib/xine-lib"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~x86"

IUSE="
aalib libcaca arts esd win32codecs nls dvd X directfb vorbis alsa gnome sdl
speex theora ipv6 altivec opengl aac fbcon xv xvmc samba dxr3 vidix mng flac
oss v4l xinerama vcd a52 mad imagemagick dts debug modplug gtk pulseaudio mmap
doc truetype wavpack musepack xcb
"

RDEPEND="
	X? ( x11-libs/libXext
		 x11-libs/libX11 )
	xv? ( x11-libs/libXv )
	xvmc? ( x11-libs/libXvMC )
	xinerama? ( x11-libs/libXinerama )
	win32codecs? ( >=media-libs/win32codecs-0.50 )
	esd? ( media-sound/esound )
	dvd? ( >=media-libs/libdvdcss-1.2.7 )
	arts? ( kde-base/arts )
	alsa? ( media-libs/alsa-lib )
	aalib? ( media-libs/aalib )
	directfb? ( >=dev-libs/DirectFB-0.9.9 )
	gnome? ( >=gnome-base/gnome-vfs-2.0 )
	flac? ( >=media-libs/flac-1.1.2 )
	sdl? ( >=media-libs/libsdl-1.1.5 )
	dxr3? ( >=media-libs/libfame-0.9.0 )
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	theora? (
		media-libs/libogg media-libs/libvorbis
		>=media-libs/libtheora-1.0_alpha6
	)
	speex? ( media-libs/libogg media-libs/libvorbis media-libs/speex )
	libcaca? ( >=media-libs/libcaca-0.99_beta1 )
	samba? ( net-fs/samba )
	mng? ( media-libs/libmng )
	vcd? ( media-video/vcdimager )
	a52? ( >=media-libs/a52dec-0.7.4-r5 )
	mad? ( media-libs/libmad )
	imagemagick? ( media-gfx/imagemagick )
	dts? ( media-libs/libdts )
	>=media-video/ffmpeg-0.4.9_p20070129
	modplug? ( media-libs/libmodplug )
	nls? ( virtual/libintl )
	gtk? ( =x11-libs/gtk+-2* )
	pulseaudio? ( media-sound/pulseaudio )
	truetype? ( =media-libs/freetype-2* media-libs/fontconfig )
	virtual/libiconv
	wavpack? ( >=media-sound/wavpack-4.31 )
	musepack? ( media-libs/libmpcdec )
	xcb? ( >=x11-libs/libxcb-1.0 )
	!=media-libs/xine-lib-0.9.13*
"
DEPEND="
	${RDEPEND}
	X? ( x11-libs/libXt
		 x11-proto/xproto
		 x11-proto/videoproto
		 x11-proto/xf86vidmodeproto
		 xinerama? ( x11-proto/xineramaproto ) )
	v4l? ( virtual/os-headers )
	doc? (
		app-text/sgmltools-lite
		media-gfx/transfig
	)
	dev-util/pkgconfig
	sys-devel/libtool
	nls? ( sys-devel/gettext )
"

src_unpack() {
	mercurial_src_unpack
	cd "${S}"
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	#prevent quicktime crashing
	append-flags -frename-registers -ffunction-sections

	# Specific workarounds for too-few-registers arch...
	if [[ $(tc-arch) == "x86" ]]; then
		filter-flags -fforce-addr
		filter-flags -momit-leaf-frame-pointer # break on gcc 3.4/4.x
		filter-flags -fno-omit-frame-pointer #breaks per bug #149704
		is-flag -O? || append-flags -O2
	fi

	# debug useflag used to emulate debug make targets. See bug #112980 and the
	# xine maintainers guide.
	use debug && append-flags -UNDEBUG -DDEBUG

	local myconf

	# enable/disable appropiate optimizations on sparc
	[[ "${PROFILE_ARCH}" == "sparc64" ]] && myconf="${myconf} --enable-vis"
	[[ "${PROFILE_ARCH}" == "sparc" ]] && myconf="${myconf} --disable-vis"

	# The default CFLAGS (-O) is the only thing working on hppa.
	use hppa && unset CFLAGS

	# Too many file names are the same (xine_decoder.c), change the builddir
	# So that the relative path is used to identify them.
	mkdir "${WORKDIR}/build"

	addpredict /usr/share/sgml/misc/sgmltools/python/backends

	if ! use doc; then
		export ac_cv_prog_SGMLTOOLS="no" ac_cv_prog_FIG2DEV="no"
	fi

	ECONF_SOURCE="${S}" econf \
		$(use_enable gnome gnomevfs) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable samba) \
		$(use_enable altivec) \
		$(use_enable v4l) \
		\
		$(use_enable mng) \
		$(use_with imagemagick) \
		$(use_enable gtk gdkpixbuf) \
		\
		$(use_enable aac faad) \
		$(use_with flac libflac) \
		$(use_with vorbis) \
		$(use_with speex) \
		$(use_with theora) \
		$(use_with wavpack) \
		$(use_enable modplug) \
		$(use_enable a52) --with-external-a52dec \
		$(use_enable mad) --with-external-libmad \
		$(use_enable dts) --with-external-libdts \
		$(use_enable musepack) --with-external-libmpcdec \
		\
		$(use_with X x) \
		$(use_enable xinerama) \
		$(use_enable vidix) \
		$(use_enable dxr3) \
		$(use_enable directfb) \
		$(use_enable fbcon fb) \
		$(use_enable opengl) \
		$(use_enable aalib) \
		$(use_with libcaca caca) \
		$(use_with sdl) \
		$(use_enable xvmc) \
		$(use_with xcb) \
		\
		$(use_enable oss) \
		$(use_with alsa) \
		$(use_with arts) \
		$(use_with esd esound) \
		$(use_with pulseaudio) \
		$(use_enable vcd) --without-internal-vcdlibs \
		\
		$(use_enable win32codecs w32dll) \
		\
		$(use_enable mmap) \
		$(use_with truetype freetype) $(use_with truetype fontconfig) \
		--enable-asf \
		--with-external-ffmpeg \
		--disable-optimizations \
		--disable-syncfb \
		${myconf} \
		--with-xv-path=/usr/$(get_libdir) \
		--with-w32-path=/usr/$(ABI=x86 get_libdir)/win32 \
		--enable-fast-install \
		--docdir="/usr/share/doc/${PF}" --htmldir="/usr/share/doc/${PF}/html" \
		--disable-dependency-tracking || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "Install failed"
	prepalldocs
}
