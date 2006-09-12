# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.8.2-r1.ebuild,v 1.2 2005/07/13 10:25:59 flameeyes Exp $

# Missing USE-flags due to missing deps:
# media-vidoe/vlc:tremor - Enables Tremor decoder support
# media-video/vlc:tarkin - Enables experimental tarkin codec

inherit wxwidgets flag-o-matic nsplugins multilib subversion autotools

PATCHLEVEL="7"
DESCRIPTION="VLC media player - Video player and streamer"
HOMEPAGE="http://www.videolan.org/vlc/"
SRC_URI="http://digilander.libero.it/dgp85/gentoo/vlc-patches-${PATCHLEVEL}.tar.bz2"
ESVN_REPO_URI="svn://svn.videolan.org/vlc/trunk"
ESVN_PATCHES="${FILESDIR}/${PN}-*.diff"
ESVN_BOOTSTRAP="bootstrap"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="a52 3dfx nls unicode debug altivec httpd vlm gnutls live v4l cdda ogg matroska
dvb dvd vcd ffmpeg aac dts flac mpeg vorbis theora X opengl truetype svg fbcon svga
oss aalib ggi libcaca esd arts alsa wxwindows ncurses xosd lirc joystick hal stream
mp3 xv bidi sdl png xml samba daap corba screen mod speex nsplugin x264
dirac gnome musepack"

RDEPEND="hal? ( >=sys-apps/hal-0.5.0 )
		cdda? ( >=dev-libs/libcdio-0.71
			>=media-libs/libcddb-0.9.5 )
		live? ( >=media-plugins/live-2005.01.29 )
		dvd? (  media-libs/libdvdread
				media-libs/libdvdcss
				>=media-libs/libdvdnav-0.1.9
				media-libs/libdvdplay )
		esd? ( media-sound/esound )
		ogg? ( media-libs/libogg )
		matroska? ( >=dev-libs/libebml-0.7.6
			>=media-libs/libmatroska-0.7.5 )
		mp3? ( media-libs/libmad )
		ffmpeg? || ( media-video/ffmpeg-svn media-video/ffmpeg )
		a52? ( media-libs/a52dec )
		dts? || ( media-libs/libdca media-libs/libdts )
		flac? ( media-libs/flac )
		mpeg? ( >=media-libs/libmpeg2-0.3.2 )
		vorbis? ( media-libs/libvorbis )
		theora? ( media-libs/libtheora )
		X? ( virtual/x11 )
		xv? ( virtual/x11 )
		truetype? ( media-libs/freetype
			media-fonts/ttf-bitstream-vera )
		svga? ( media-libs/svgalib )
		ggi? ( media-libs/libggi )
		aalib? ( media-libs/aalib )
		libcaca? ( media-libs/libcaca )
		arts? ( kde-base/arts )
		alsa? ( virtual/alsa )
		wxwindows? ( =x11-libs/wxGTK-2.6* )
		ncurses? ( sys-libs/ncurses )
		xosd? ( x11-libs/xosd )
		lirc? ( app-misc/lirc )
		3dfx? ( media-libs/glide-v3 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		gnutls? ( >=net-libs/gnutls-1.0.17 )
		opengl? ( virtual/opengl )
		sys-libs/zlib
		png? ( media-libs/libpng )
		media-libs/libdvbpsi
		aac? ( >=media-libs/faad2-2.0-r2 )
		sdl? ( media-libs/sdl-image )
		xml? ( dev-libs/libxml2 )
		samba? ( net-fs/samba )
		vcd? ( >=dev-libs/libcdio-0.72
			>=media-video/vcdimager-0.7.21 )
		daap? ( >=media-libs/libopendaap-0.3.0 )
		corba? ( >=gnome-base/orbit-2.8.0
			>=dev-libs/glib-2.3.2 )
		v4l? ( sys-kernel/linux-headers )
		dvb? ( sys-kernel/linux-headers )
		joystick? ( sys-kernel/linux-headers )
		mod? ( media-libs/libmodplug )
		speex? ( media-libs/speex )
		svg? ( >=gnome-base/librsvg-2.5.0 )
		x264? ( media-libs/x264 )
		dirac? ( media-video/dirac )
		musepack? ( media-libs/libmpcdec )
		gnome? ( =gnome-base/gnome-vfs-2* )
		nsplugin? ( >=net-libs/gecko-sdk-1.7.8 )"
#		threads? ( dev-libs/pth )
#		portaudio? ( >=media-libs/portaudio-0.19 )
# 		slp? ( net-libs/openslp )

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	if has_version '>=media-video/dirac-0.5.0'; then
		DIRAC_INC="`pkg-config dirac --cflags-only-I --silence-errors`"
	fi
}

src_unpack() {
	if use wxwindows; then
		WX_GTK_VER="2.6"
		if use unicode; then
			need-wxwidgets unicode || die "You need to install wxGTK with unicode support."
		else
			need-wxwidgets gtk2 || die "You need to install wxGTK with gtk2 support."
		fi
	fi

	export SKIP_AUTOTOOLS="indeed"
	subversion_src_unpack
	REVISION="$(svnversion \
		${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/})"
	sed -i "s:\(VLC_CHANGESET=\)'.*:\1${REVISION}:" ${S}/toolbox

	cd ${S}

	sed -i -e \
		"s:/glide:/glide3:; s:glide2x:glide3:" configure.ac || die "sed glide failed."
	# Fix the default font
	sed -i -e \
		"s:/truetype/freefont/FreeSerifBold.ttf:/ttf-bitstream-vera/VeraBd.ttf:" \
		modules/misc/freetype.c

	# helps -Wl,--as-needed
	sed -i "s:\(libvlc_la_LIBADD = .*\):\1 -ldl:" src/Makefile.am

	autopoint -f
	AT_M4DIR="${S}/m4"
	eautoreconf
}

src_compile () {
	# reason why:
	# skins2 interface is horribly broken for some reason.
	# Therefore it's being disabled for the standard wxwindows
	# interface which isn't
	myconf="${myconf} --disable-skins2"

	use nsplugin && myconf="${myconf} --with-mozilla-sdk-path=/usr/$(get_libdir)/gecko-sdk"

	use wxwindows && \
		myconf="${myconf} --with-wx-config=$(basename ${WX_CONFIG}) --with-wx-config-path=$(dirname ${WX_CONFIG})"

	# Portaudio support needs at least v19
	# pth (threads) support is quite unstable with latest ffmpeg/libmatroska.
	CPPFLAGS="${CPPFLAGS} ${DIRAC_INC}" \
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
		$(use_enable dvb) $(use_enable dvb pvr) \
		$(use_enable ogg) \
		$(use_enable matroska mkv) \
		$(use_enable flac) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable X x11) \
		$(use_enable xv xvideo) \
		$(use_enable opengl glx) $(use_enable opengl) \
		$(use_enable truetype freetype) \
		$(use_enable bidi fribidi) \
		$(use_enable dvd dvdread) $(use_enable dvd dvdplay) $(use_enable dvd dvdnav) \
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
		$(use_enable live live555) $(use_with live live555-tree /usr/lib/live) \
		$(use_enable mp3 mad) \
		$(use_enable aac faad) \
		$(use_enable a52) \
		$(use_enable dts) \
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
		--disable-pth \
		--disable-portaudio \
		--disable-slp \
		${myconf} || die "configuration failed"

	emake || die "make of VLC failed"
}

src_install() {
	make DESTDIR="${D}" plugindir="/usr/$(get_libdir)/${PLUGINS_DIR}" install || die "Installation failed!"

	dodoc AUTHORS MAINTAINERS HACKING THANKS TODO NEWS README \
		doc/fortunes.txt doc/intf-cdda.txt doc/intf-vcd.txt

	rm -r ${D}/usr/share/vlc/{,k,q,g,gnome-}vlc*.{png,xpm} \
		${D}/usr/share/vlc/vlc*.ico ${D}/usr/share/vlc/skins2 \
		${D}/usr/share/doc/vlc

	for res in 16 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps/
		newins ${S}/share/vlc${res}x${res}.png vlc.png
	done
}
