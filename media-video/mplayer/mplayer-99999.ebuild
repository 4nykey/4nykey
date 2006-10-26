# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer/mplayer-1.0_pre8-r1.ebuild,v 1.12 2006/10/06 12:43:24 blubb Exp $

inherit flag-o-matic linux-mod subversion

BLUV=1.6
SVGV=1.9.17
NBV=610
WBV=600
SKINDIR="/usr/share/mplayer/skins/"
DESCRIPTION="Media Player for Linux"
HOMEPAGE="http://www.mplayerhq.hu/"
SRC_URI="
	bitmap-fonts? (
		mirror://mplayer/releases/fonts/font-arial-iso-8859-1.tar.bz2
		mirror://mplayer/releases/fonts/font-arial-iso-8859-2.tar.bz2
		mirror://mplayer/releases/fonts/font-arial-cp1250.tar.bz2
	)
	svga? ( http://mplayerhq.hu/~alex/svgalib_helper-${SVGV}-mplayer.tar.bz2 )
	amr? (
		http://www.3gpp.org/ftp/Specs/archive/26_series/26.204/26204-${WBV}.zip
		http://www.3gpp.org/ftp/Specs/archive/26_series/26.104/26104-${NBV}.zip
	)
	gtk? ( mirror://mplayer/Skin/Blue-${BLUV}.tar.bz2 )
"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/mplayer/trunk"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="
3dfx 3dnow 3dnowext aac aalib alsa amr arts bindist bitmap-fonts bidi bl cdio
cpudetection custom-cflags debug dga doc dts dvb cdparanoia directfb dv dvd
dvdread dvdnav enca encode esd external-faad external-ffmpeg fbcon fontconfig
gif ggi gtk ipv6 jack joystick jpeg ladspa libcaca lirc live livecd lzo mad
matrox mmx mmxext musepack nas openal opengl oss png real rtc samba sdl speex
sse sse2 svga tga theora tremor truetype v4l v4l2 vorbis win32codecs X x264
xanim xinerama xmms xv xvid xvmc twolame
"

# 'encode' in USE for MEncoder.
RDEPEND="
	xvid? ( >=media-libs/xvid-0.9.0 )
	win32codecs? (
		!livecd? (
			!bindist? ( >=media-libs/win32codecs-20040916 ) ) )
	x86? ( real? ( >=media-video/realplayer-10.0.3 ) )
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	openal? ( media-libs/openal )
	bidi? ( dev-libs/fribidi )
	cdio? ( dev-libs/libcdio )
	cdparanoia? ( media-sound/cdparanoia )
	dga? ( x11-libs/libXxf86dga )
	directfb? ( dev-libs/DirectFB )
	dts? (
		|| (
			media-libs/libdca
			media-libs/libdts
		)
	)
	dvb? ( media-tv/linuxtv-dvb-headers )
	dvd? ( dvdread? ( media-libs/libdvdread ) )
	encode? (
		media-sound/lame
		media-sound/twolame
		dv? ( >=media-libs/libdv-0.9.5 )
		aac? ( media-libs/faac )
		x264? ( >=media-libs/x264-45 )
	)
	esd? ( media-sound/esound )
	external-ffmpeg? ( media-video/ffmpeg )
	enca? ( app-i18n/enca )
	gif? ( media-libs/giflib )
	ggi? ( media-libs/libggi )
	gtk? (
		media-libs/libpng
		x11-libs/libXxf86vm
		x11-libs/libXext
		x11-libs/libXi
		=x11-libs/gtk+-2*
		=dev-libs/glib-2*
	)
	jpeg? ( media-libs/jpeg )
	libcaca? ( media-libs/libcaca )
	lirc? ( app-misc/lirc )
	lzo? ( dev-libs/lzo )
	mad? ( media-libs/libmad )
	musepack? ( >=media-libs/libmpcdec-1.2.2 )
	nas? ( media-libs/nas )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng )
	samba? ( >=net-fs/samba-2.2.8a )
	sdl? ( media-libs/libsdl )
	speex? ( media-libs/speex )
	svga? ( media-libs/svgalib )
	theora? ( media-libs/libtheora )
	live? ( >=media-plugins/live-2004.07.20 )
	truetype? ( >=media-libs/freetype-2.1 )
	xinerama? (
		x11-libs/libXinerama
		x11-libs/libXxf86vm
		x11-libs/libXext
	)
	jack? ( media-sound/jack-audio-connection-kit )
	xmms? ( media-sound/xmms )
	xanim? ( >=media-video/xanim-2.80.1-r4 )
	external-faad? ( media-libs/faad2 )
	sys-libs/ncurses
	dvdnav? ( media-libs/libdvdnav )
	ladspa? ( media-libs/ladspa-sdk )
	fontconfig? ( media-libs/fontconfig )
	xv? (
		x11-libs/libXv
		x11-libs/libXxf86vm
		x11-libs/libXext
		xvmc? ( x11-libs/libXvMC )
	)
	X? (
		x11-libs/libXxf86vm
		x11-libs/libXext
	)
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	doc? (
		dev-libs/libxslt
		>=app-text/docbook-xml-dtd-4.1.2
		>=app-text/docbook-xsl-stylesheets-1.62.4
	)
	amr? ( app-arch/unzip )
	dga? ( x11-proto/xf86dgaproto )
	xinerama? ( x11-proto/xineramaproto )
	xv? ( x11-proto/videoproto
		  x11-proto/xf86vidmodeproto )
	gtk? ( x11-proto/xextproto
		   x11-proto/xf86vidmodeproto )
	X? ( x11-proto/xextproto
		 x11-proto/xf86vidmodeproto )
"

teh_conf() {
	# avoid using --enable-xxx options,
	# except {gui,debug} and those, disabled by default
	if ! use $1; then
		myconf="${myconf} --disable-$([[ -n "$2" ]] && echo $2 || echo $1)"
	fi
}

pkg_setup() {
	if use real && use x86; then
		REALLIBDIR="/opt/RealPlayer/codecs"
	fi
	LINGUAS="en"
}

src_unpack() {
	subversion_src_unpack

	# get svn revision for version.h
	REVISION="$(svnversion \
		${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/})"
	sed -i "s:\(svn_revision=\)UNKNOWN:\1${REVISION}:" ${S}/version.sh

	cd ${WORKDIR}

	if use amr; then
		unpack 26104-${NBV}.zip 26204-${WBV}.zip
		unzip -ajq 26204-${WBV}_ANSI-C_source_code.zip -d ${S}/libavcodec/amrwb_float
		unzip -ajq 26104-${NBV}_ANSI_C_source_code.zip -d ${S}/libavcodec/amr_float
	fi

	if use bitmap-fonts; then
		unpack \
			font-arial-iso-8859-1.tar.bz2 font-arial-iso-8859-2.tar.bz2 \
			font-arial-cp1250.tar.bz2
	fi


	use gtk && unpack Blue-${BLUV}.tar.bz2

	if use svga
	then
		unpack svgalib_helper-${SVGV}-mplayer.tar.bz2

		echo
		einfo "Enabling svga non-root mode."
		einfo "(You need a proper svgalib_helper.o module for your kernel"
		einfo " to actually use this)"
		echo

		mv ${WORKDIR}/svgalib_helper ${S}/libdha
	fi

	cd ${S}

	EPATCH_SUFFIX="diff" epatch "${FILESDIR}"

	# skip make distclean/depend
	touch .developer
	sed -i '/\$(MAKE) depend/d' Makefile
	# skip stripping
	sed -i 's:\(_stripbinaries=\).*:\1no:' configure

	has_version '>=media-sound/twolame-0.3.4' && \
		sed -i 's:twolame_set_VBR_q:twolame_set_VBR_level:' libmpcodecs/ae_twolame.c
}

src_compile() {

	local myconf="${myconf} --disable-tv-bsdbt848 --disable-vidix-external"
	################
	#Optional features#
	###############
	if use cpudetection || use livecd || use bindist
	then
	myconf="${myconf} --enable-runtime-cpudetection"
	fi

	teh_conf bidi fribidi

	teh_conf enca

	if use cdio; then
		myconf="${myconf} --disable-cdparanoia"
	else
		teh_conf cdparanoia
	fi

	if use external-ffmpeg; then # use shared ffmpeg libs
		for lib in avutil avcodec avformat postproc; do
			myconf="${myconf} --disable-lib$lib"
		done
	fi

	if use dvd; then
		if ! use dvdnav; then
			myconf="${myconf} --disable-dvdnav"
			if use dvdread; then
				myconf="${myconf} --disable-mpdvdkit"
			else
				myconf="${myconf} --disable-dvdread"
			fi
		fi
	else
		myconf="${myconf} --disable-dvdread --disable-mpdvdkit --disable-dvdnav"
	fi

	if use encode ; then
		teh_conf dv libdv
		teh_conf x264
		teh_conf twolame
		teh_conf aac faac
	else
		myconf="${myconf} --disable-mencoder --disable-libdv --disable-x264"
		myconf="${myconf} --disable-twolame --disable-faac"
	fi

	if use !gtk && use !X && use !xv && use !xinerama; then
		myconf="${myconf} --disable-gui --disable-x11 --disable-xv --disable-xmga --disable-xinerama --disable-vm --disable-xvmc"
	else
		#note we ain't touching --enable-vm.  That should be locked down in the future.
		myconf="${myconf} $(use_enable gtk gui)"
		teh_conf xinerama
		teh_conf xv
	fi

	teh_conf dga
	teh_conf 3dfx dga

	# disable png *only* if gtk && png aren't on
	if ! use png || ! use gtk; then
		myconf="${myconf} --disable-png"
	fi
	teh_conf ipv6 inet6
	myconf="${myconf} $(use_enable joystick)"
	teh_conf lirc
	teh_conf live
	teh_conf rtc
	teh_conf samba smb
	teh_conf bitmap-fonts bitmap-font
	teh_conf truetype freetype
	teh_conf fontconfig
	teh_conf v4l tv-v4l1
	teh_conf v4l2 tv-v4l2

	#######
	# Codecs #
	#######
	teh_conf gif
	teh_conf jpeg
	teh_conf ladspa
	teh_conf dts libdts
	teh_conf lzo liblzo
	teh_conf musepack
	if use aac; then
		use external-faad && myconf="${myconf} --disable-faad-internal"
	else
		myconf="${myconf} --disable-faad-internal --disable-faad-external"
	fi
	if use vorbis; then
		teh_conf tremor tremor-internal
		teh_conf tremor tremor-external
	else
		myconf="${myconf} --disable-vorbis"
	fi
	teh_conf theora
	teh_conf speex
	use xmms && myconf="${myconf} --enable-xmms"
	teh_conf xvid
	use x86 && teh_conf real
	! use livecd && ! use bindist && \
		teh_conf win32codecs win32
	teh_conf amr amr_nb
	teh_conf amr amr_wb
	myconf="${myconf} --disable-amr_nb-fixed"

	#############
	# Video Output #
	#############
	if use 3dfx; then
		myconf="${myconf} --enable-3dfx --enable-tdfxvid"
		use fbcon && myconf="${myconf} --enable-tdfxfb"
	else
		myconf="${myconf} --disable-tdfxvid"
	fi

	teh_conf dvb dvbhead
	use dvb && myconf="${myconf} --with-dvbincdir=/usr/include"

	teh_conf aalib aa
	teh_conf directfb
	teh_conf fbcon fbdev
	teh_conf ggi
	teh_conf libcaca caca
	use X && teh_conf matrox xmga
	teh_conf matrox mga
	teh_conf opengl gl
	teh_conf sdl

	teh_conf svga
	teh_conf svga vidix-internal

	teh_conf tga

	if use xv && use xvmc
	then
		myconf="${myconf} --enable-xvmc --with-xvmclib=XvMCW"
	else
		myconf="${myconf} --disable-xvmc"
	fi

	#############
	# Audio Output #
	#############
	teh_conf alsa
	teh_conf jack
	teh_conf arts
	teh_conf esd
	teh_conf mad
	teh_conf nas
	teh_conf openal
	teh_conf oss ossaudio

	#################
	# Advanced Options #
	#################
	if use x86; then
		teh_conf 3dnow
		teh_conf 3dnowext
		teh_conf sse
		teh_conf sse2
		teh_conf mmx
		teh_conf mmxext
	fi
	use debug && myconf="${myconf} --enable-debug=3"

	if use xanim
	then
		myconf="${myconf} --with-xanimlibdir=/usr/lib/xanim/mods"
	fi

	if [ -e /dev/.devfsd ]
	then
		myconf="${myconf} --enable-linux-devfs"
	fi

	use xmms && myconf="${myconf} --with-xmmslibdir=/usr/$(get_libdir)"

	use live && myconf="${myconf} --with-livelibdir=/usr/$(get_libdir)/live"

	# support for blinkenlights
	use bl && myconf="${myconf} --enable-bl"

	#leave this in place till the configure/compilation borkage is completely corrected back to pre4-r4 levels.
	# it's intended for debugging so we can get the options we configure mplayer w/, rather then hunt about.
	# it *will* be removed asap; in the meantime, doesn't hurt anything.
	echo "${myconf}" > ${T}/configure-options

	if use custom-cflags
	then
	# let's play the filtration game!  MPlayer hates on all!
	#strip-flags
	# ugly optimizations cause MPlayer to cry on x86 systems!
		if use x86 ; then
			replace-flags -O0 -O2
			replace-flags -O3 -O2
			filter-flags -fPIC -fPIE
		fi
	else
	unset CFLAGS CXXFLAGS
	fi

	CFLAGS="$CFLAGS" ./configure \
		--prefix=/usr \
		--confdir=/usr/share/mplayer \
		--datadir=/usr/share/mplayer \
		--enable-largefiles \
		--enable-menu \
		--enable-network --enable-ftp \
		--with-reallibdir=${REALLIBDIR} \
		${myconf} || die

	# we run into problems if -jN > -j1
	# see #86245
	MAKEOPTS="${MAKEOPTS} -j1"

	einfo "Make"
	emake || die "Failed to build MPlayer!"
	use doc && make -C ${S}/DOCS/xml html-chunked-en
	einfo "Make completed"
}

src_install() {

	einfo "Make install"
	make prefix=${D}/usr \
	     BINDIR=${D}/usr/bin \
		 LIBDIR=${D}/usr/$(get_libdir) \
	     CONFDIR=${D}/usr/share/mplayer \
	     DATADIR=${D}/usr/share/mplayer \
	     MANDIR=${D}/usr/share/man \
	     install || die "Failed to install MPlayer!"
	einfo "Make install completed"

	dodoc AUTHORS ChangeLog README
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		dohtml -r "${S}/DOCS/HTML/en/"
		# Copy misc tools to documentation path, as they're not installed directly
		# and yes, we are nuking the +x bit.
		find "${S}/TOOLS" -type d | xargs -- chmod 0755
		find "${S}/TOOLS" -type f | xargs -- chmod 0644
		cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die
		cp -r "${S}/DOCS/tech" "${D}/usr/share/doc/${PF}/"
	fi

	# Install the default Skin and Gnome menu entry
	if use gtk; then
		if [ -d "${ROOT}${SKINDIR}default" ]; then dodir ${SKINDIR}; fi
		cp -r ${WORKDIR}/Blue ${D}${SKINDIR}default || die

		# Fix the symlink
		rm -rf ${D}/usr/bin/gmplayer
		dosym mplayer /usr/bin/gmplayer
	fi

	if use bitmap-fonts; then
		dodir /usr/share/mplayer/fonts
		local x=
		# Do this generic, as the mplayer people like to change the structure
		# of their zips ...
		for x in $(find ${WORKDIR}/ -type d -name 'font-arial-*')
		do
			cp -Rd ${x} ${D}/usr/share/mplayer/fonts
		done
		# Fix the font symlink ...
		rm -rf ${D}/usr/share/mplayer/font
		dosym fonts/font-arial-14-iso-8859-1 /usr/share/mplayer/font
	fi

	insinto /etc
	newins ${S}/etc/example.conf mplayer.conf
	dosed -e 's/include =/#include =/' /etc/mplayer.conf
	dosed -e 's/fs=yes/fs=no/' /etc/mplayer.conf
	dosym ../../../etc/mplayer.conf /usr/share/mplayer/mplayer.conf

	# mv the midentify script to /usr/bin for emovix.
	insinto /usr/bin
	insopts -m0755
	doins TOOLS/midentify
	insinto /usr/share/mplayer
	dodoc ${S}/etc/codecs.conf
	doins ${S}/etc/input.conf
	doins ${S}/etc/menu.conf
}

pkg_preinst() {

	if [ -d "${ROOT}${SKINDIR}default" ]
	then
		rm -rf ${ROOT}${SKINDIR}default
	fi
}

pkg_postinst() {

	if use matrox; then
		depmod -a &>/dev/null || :
	fi
}

pkg_postrm() {

	# Cleanup stale symlinks
	if [ -L ${ROOT}/usr/share/mplayer/font -a \
	     ! -e ${ROOT}/usr/share/mplayer/font ]
	then
		rm -f ${ROOT}/usr/share/mplayer/font
	fi

	if [ -L ${ROOT}/usr/share/mplayer/subfont.ttf -a \
	     ! -e ${ROOT}/usr/share/mplayer/subfont.ttf ]
	then
		rm -f ${ROOT}/usr/share/mplayer/subfont.ttf
	fi
}

