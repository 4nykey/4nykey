# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.8.2-r1.ebuild,v 1.2 2005/07/13 10:25:59 flameeyes Exp $

# Missing USE-flags due to missing deps:
# media-vidoe/vlc:tremor - Enables Tremor decoder support
# media-video/vlc:tarkin - Enables experimental tarkin codec

inherit wxwidgets-nu flag-o-matic nsplugins multilib subversion autotools qt4

AT_M4DIR="m4"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"
ESVN_REPO_URI="svn://svn.videolan.org/vlc/trunk"
ESVN_PATCHES="${FILESDIR}/${PN}-*.diff"
ESVN_BOOTSTRAP="./bootstrap && eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
a52 3dfx nls unicode debug altivec httpd vlm gnutls live v4l cdda ogg matroska
dvb dvd vcd ffmpeg aac dts flac mpeg vorbis theora X opengl truetype svg fbcon
svga oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc joystick
hal stream mp3 xv bidi sdl png xml samba daap corba mod speex nsplugin x264
dirac gnome musepack qt4 portaudio skins firefox xulrunner shout lua libnotify
musicbrainz taglib ieee1394 dv twolame real rtsp teletext zvbi upnp win32codecs
cddb directfb jack avahi optimisememory xinerama
"
#	upnp? ( net-misc/clinkcc )
#		$(use_enable upnp cyberlink) \

RDEPEND="
	hal? ( >=sys-apps/hal-0.5.0 )
	cdda? (
		>=dev-libs/libcdio-0.71
		cddb? ( >=media-libs/libcddb-0.9.5 )
	)
	live? ( >=media-plugins/live-2007.01.17 )
	dvd? (
		media-libs/libdvdread
		media-libs/libdvdcss
		>=media-libs/libdvdnav-0.1.9
		media-libs/libdvdplay
	)
	esd? ( media-sound/esound )
	ogg? ( media-libs/libogg )
	matroska? (
		>=dev-libs/libebml-0.7.6
		>=media-libs/libmatroska-0.7.5
	)
	mp3? ( media-libs/libmad )
	ffmpeg? ( media-video/ffmpeg )
	a52? ( media-libs/a52dec )
	dts? ( media-libs/libdca )
	flac? ( media-libs/flac )
	mpeg? ( >=media-libs/libmpeg2-0.3.2 )
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		xv? ( x11-libs/libXv )
		xinerama? ( x11-libs/libXinerama )
		opengl? ( virtual/opengl )
	)
	truetype? (
		media-libs/freetype
		media-fonts/ttf-bitstream-vera
	)
	svga? ( media-libs/svgalib )
	ggi? ( media-libs/libggi )
	aalib? ( media-libs/aalib )
	libcaca? ( media-libs/libcaca )
	arts? ( kde-base/arts )
	alsa? ( virtual/alsa )
	wxwindows? ( >=x11-libs/wxGTK-2.6 )
	skins? ( >=x11-libs/wxGTK-2.6 )
	ncurses? ( sys-libs/ncurses )
	xosd? ( x11-libs/xosd )
	lirc? ( app-misc/lirc )
	3dfx? ( media-libs/glide-v3 )
	bidi? ( >=dev-libs/fribidi-0.10.4 )
	gnutls? ( >=net-libs/gnutls-1.0.17 )
	opengl? ( virtual/opengl )
	sys-libs/zlib
	png? ( media-libs/libpng )
	dvb? ( media-libs/libdvbpsi )
	aac? ( >=media-libs/faad2-2.0-r2 )
	sdl? ( media-libs/sdl-image )
	xml? ( dev-libs/libxml2 )
	samba? ( net-fs/samba )
	vcd? (
		>=dev-libs/libcdio-0.72
		>=media-video/vcdimager-0.7.21
	)
	daap? ( >=media-libs/libopendaap-0.3.0 )
	corba? (
		>=gnome-base/orbit-2.8.0
		>=dev-libs/glib-2.3.2
	)
	mod? ( media-libs/libmodplug )
	speex? ( media-libs/speex )
	svg? ( >=gnome-base/librsvg-2.5.0 )
	x264? ( media-libs/x264 )
	dirac? ( media-video/dirac )
	musepack? ( media-libs/libmpcdec )
	gnome? ( =gnome-base/gnome-vfs-2* )
	nsplugin? (
		firefox? ( www-client/mozilla-firefox )
		!firefox? (
			xulrunner? ( net-libs/xulrunner )
			!xulrunner? ( www-client/seamonkey )
		)
	)
	portaudio? ( >=media-libs/portaudio-0.19 )
	qt4? ( $(qt4_min_version 4) )
	lua? ( >=dev-lang/lua-5.1 )
	shout? ( >=media-libs/libshout-2.1 )
	libnotify? ( x11-libs/libnotify )
	musicbrainz? ( media-libs/musicbrainz )
	taglib? ( media-libs/taglib )
	ieee1394? (
		media-libs/libdc1394
		sys-libs/libraw1394
		dv? ( sys-libs/libavc1394 )
	)
	twolame? ( media-sound/twolame )
	zvbi? ( >=media-libs/zvbi-0.2.25 )
	upnp? ( net-libs/libupnp )
	win32codecs? ( media-libs/win32codecs )
	directfb? ( dev-libs/DirectFB )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0-r1 )
	avahi? ( >=net-dns/avahi-0.6 )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	v4l? ( virtual/os-headers )
	dvb? ( virtual/os-headers )
	joystick? ( virtual/os-headers )
	X? ( xinerama? ( x11-proto/xineramaproto ) )
	sys-devel/gettext
	dev-util/pkgconfig
"

pkg_setup() {
	if use wxwindows || use skins; then
		WX_GTK_VER="2.6"
		if use unicode; then
			need-wxwidgets unicode
		else
			need-wxwidgets gtk2
		fi
	fi
	if use skins && ! use truetype; then
		eerror "Trying to build with skins support but without truetype."
		die "You have to use 'truetype' to use 'skins'"
	fi
}

src_compile () {
	local myconf="${myconf} --with-tuning=no"

	# configure will pick firefox by pkg-config and use it by default
	# if we have firefox installed, but want plugin built against xulrunner
	# or seamonkey, `sdk-path' is the only way to override
	if use nsplugin && use !firefox; then
		CPPFLAGS="${CPPFLAGS} $(nspr-config --cflags)"
		if use xulrunner; then
			myconf="${myconf} --with-mozilla-sdk-path=/usr/lib/xulrunner"
		else
			myconf="${myconf} --with-mozilla-sdk-path=/usr/lib/seamonkey"
		fi
	fi


	if use wxwindows || use skins; then
		myconf="${myconf} --with-wx-config=${WX_CONFIG_NAME}"
		myconf="${myconf} --with-wx-config-path=${WX_CONFIG_PREFIX}"
		# quoting configure
		elog "wxWidgets support is deprecated and will be removed"
		elog "Consider using Qt4 instead"
	fi

	if use ieee1394; then
		myconf="${myconf} $(use_enable dv) $(use_with dv dv-raw1394) \
		$(use_with dv dv-avc1394)"
	fi

	if use teletext; then
		myconf="${myconf} $(use_enable zvbi) $(use_enable !zvbi telx)"
	fi

	if use cdda; then
		myconf="${myconf} $(use_enable cddb libcddb)"
	fi

	if use directfb; then
		myconf="${myconf} --enable-directfb --with-directfb=/usr"
		append-cppflags "-I/usr/include/directfb"
	else
		myconf="${myconf} --disable-directfb"
	fi

	econf \
		$(use_enable ffmpeg) \
		$(use_enable altivec) \
		$(use_enable unicode utf8) \
		$(use_enable stream sout) \
		$(use_enable httpd) \
		$(use_enable vlm) \
		$(use_enable gnutls) \
		$(use_enable v4l) \
		$(use_enable cdda) \
		$(use_enable vcd) \
		$(use_enable dvb) \
		$(use_enable dvb pvr) \
		$(use_enable dvb dvbpsi) \
		$(use_enable ogg) \
		$(use_enable matroska mkv) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable X x11) \
		$(use_enable X screen) \
		$(use_enable xv xvideo) \
		$(use_enable opengl glx) \
		$(use_enable opengl) \
		$(use_enable truetype freetype) \
		$(use_enable bidi fribidi) \
		$(use_enable dvd dvdread) \
		$(use_enable dvd dvdplay) \
		$(use_enable dvd dvdnav) \
		$(use_enable fbcon fb) \
		$(use_enable svga svgalib) \
		$(use_enable 3dfx glide) \
		$(use_enable aalib aa) \
		$(use_enable libcaca caca) \
		$(use_enable oss) \
		$(use_enable esd) \
		$(use_enable arts) \
		$(use_enable alsa) \
		$(use_enable wxwindows wxwidgets) \
		$(use_enable ncurses) \
		$(use_enable xosd) \
		$(use_enable lirc) \
		$(use_enable joystick) \
		$(use_enable live live555) \
		$(use_enable mp3 mad) \
		$(use_enable aac faad) \
		$(use_enable a52) \
		$(use_enable dts dca) \
		$(use_enable mpeg libmpeg2) \
		$(use_enable ggi) \
		$(use_enable 3dfx glide) \
		$(use_enable sdl) \
		$(use_enable hal) \
		$(use_enable png) \
		$(use_enable xml libxml2) \
		$(use_enable samba smb) \
		$(use_enable daap) \
		$(use_enable corba) \
		$(use_enable mod) \
		$(use_enable speex) \
		$(use_enable dirac) \
		$(use_enable musepack mpc) \
		$(use_enable gnome gnomevfs) \
		$(use_enable nsplugin mozilla) \
		$(use_enable portaudio) \
		$(use_enable qt4) \
		$(use_enable skins skins2) \
		$(use_enable shout) \
		$(use_enable lua) \
		$(use_enable libnotify notify) \
		$(use_enable musicbrainz) \
		$(use_enable taglib) \
		$(use_enable ieee1394 dc1394) \
		$(use_enable twolame) \
		$(use_enable real) \
		$(use_enable rtsp realrtsp) \
		$(use_enable upnp) \
		$(use_enable win32codecs loader) \
		$(use_enable jack) \
		$(use_enable avahi bonjour) \
		$(use_enable optimisememory optimize-memory) \
		$(use_enable xinerama) \
		${myconf} || die "configuration failed"

	emake || die "make of VLC failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		plugindir="/usr/$(get_libdir)/${PLUGINS_DIR}" \
		install \
		|| die "Installation failed!"

	dodoc AUTHORS MAINTAINERS HACKING THANKS TODO NEWS README \
		doc/{,subtitles}/*.txt

	for res in 16 32 48 128; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/share/vlc${res}x${res}.png vlc.png
	done
}
