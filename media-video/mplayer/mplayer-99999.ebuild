# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mplayer/mplayer-1.0_pre8-r1.ebuild,v 1.12 2006/10/06 12:43:24 blubb Exp $

inherit flag-o-matic subversion confutils

BLUV=1.7
SVGV=1.9.17
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
	gtk? ( mirror://mplayer/skins/Blue-${BLUV}.tar.bz2 )
"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/mplayer/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_OPTIONS+=" --ignore-externals"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

IUSE="
3dnow 3dnowext aac aalib alsa amr arts bindist bitmap-fonts bidi bl cdio
cpudetection custom-cflags debug dga doc dts dvb cdparanoia directfb dv
dvdread dvdnav enca encode esd external-faad external-ffmpeg fbcon fontconfig
gif ggi gtk ipv6 jack joystick jpeg ladspa libcaca lirc live lzo mad
mmx mmxext musepack nas openal opengl oss png real rtc samba sdl speex
sse sse2 ssse3 svga tga theora tremor truetype v4l v4l2 vidix vorbis
win32codecs X x264 xanim xinerama xv xvid xvmc twolame radio examples zoran
pulseaudio cddb dirac schroedinger mp3 srt
"

VIDEO_CARDS="s3virge mga tdfx vesa"
for x in ${VIDEO_CARDS}; do
	IUSE="${IUSE} video_cards_${x}"
done

# 'encode' in USE for MEncoder.
RDEPEND="
	xvid? ( >=media-libs/xvid-0.9.0 )
	!bindist? (
		x86? (
			win32codecs? ( media-libs/win32codecs )
			real? ( media-libs/win32codecs
				media-video/realplayer )
			)
		amd64? ( real? ( media-libs/amd64codecs ) )
	)
	aalib? ( media-libs/aalib )
	alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )
	openal? ( media-libs/openal )
	bidi? ( dev-libs/fribidi )
	cdio? ( dev-libs/libcdio )
	cdparanoia? ( media-sound/cdparanoia )
	directfb? ( dev-libs/DirectFB )
	dts? ( media-libs/libdca )
	dvb? ( media-tv/linuxtv-dvb-headers )
	dvdread? ( media-libs/libdvdread )
	encode? (
		mp3? ( media-sound/lame )
		media-sound/twolame
		dv? ( >=media-libs/libdv-0.9.5 )
		aac? ( media-libs/faac )
		x264? ( >=media-libs/x264-45 )
	)
	esd? ( media-sound/esound )
	external-ffmpeg? ( ~media-video/ffmpeg-9999 )
	enca? ( app-i18n/enca )
	gif? ( media-libs/giflib )
	ggi? ( media-libs/libggi )
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
	jack? ( media-sound/jack-audio-connection-kit )
	xanim? ( >=media-video/xanim-2.80.1-r4 )
	external-faad? ( media-libs/faad2 )
	sys-libs/ncurses
	dvdnav? ( media-libs/libdvdnav )
	ladspa? ( media-libs/ladspa-sdk )
	fontconfig? ( media-libs/fontconfig )
	X? (
		x11-libs/libXxf86vm
		x11-libs/libXext
		dga? ( x11-libs/libXxf86dga )
		xv? (
			x11-libs/libXv
			xvmc? ( x11-libs/libXvMC )
		)
		xinerama? (
			x11-libs/libXinerama
		)
		gtk? (
			media-libs/libpng
			x11-libs/libXi
			=x11-libs/gtk+-2*
			=dev-libs/glib-2*
		)
		vidix? ( x11-libs/libXxf86vm x11-libs/libXext )
	)
	amr? ( media-libs/amrnb media-libs/amrwb )
	vorbis? ( media-libs/libvorbis )
	pulseaudio? ( media-sound/pulseaudio )
	dirac? ( media-video/dirac )
	schroedinger? ( media-libs/schroedinger )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	doc? (
		dev-libs/libxslt
		>=app-text/docbook-xml-dtd-4.1.2
	)
	X? (
		x11-proto/xextproto
		x11-proto/xf86vidmodeproto
		dga? ( x11-proto/xf86dgaproto )
		xv? (
			x11-proto/videoproto
		)
		xinerama? ( x11-proto/xineramaproto )
	)
"

pkg_setup() {
	if use real && use x86; then
		REALLIBDIR="/opt/RealPlayer/codecs"
	fi
	LINGUAS="en"
	confutils_use_conflict win32codecs real bindist
	confutils_use_depend_all gtk X png
	confutils_use_depend_any gtk bitmap-fonts truetype
	confutils_use_depend_all dga X
	confutils_use_depend_all xv X
	confutils_use_depend_all xvmc X
	confutils_use_depend_all xinerama X
	confutils_use_depend_all dv encode
	confutils_use_depend_all x264 encode
	confutils_use_depend_all twolame encode
	confutils_use_depend_all aac encode
	confutils_use_depend_any radio v4l v4l2
	confutils_use_conflict cdparanoia cdio
	confutils_use_depend_any cddb cdparanoia cdio
	confutils_use_depend_all srt truetype fontconfig
}

src_unpack() {
	subversion_fetch

	local _fflibs="avutil avformat"
	if use !external-ffmpeg; then
		_fflibs+=" avcodec postproc"
	else
		ESVN_PATCHES+=" ${PN}-ext_ffmpeg.patch"
	fi
	for e in ${_fflibs}; do
		ESVN_PROJECT="ffmpeg/trunk" subversion_fetch \
			svn://svn.mplayerhq.hu/ffmpeg/trunk/lib${e} lib${e}
	done

	subversion_bootstrap

	cd ${WORKDIR}

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

		mv ${WORKDIR}/svgalib_helper libdha
	fi
}

src_compile() {

	local my_conf="
		--cc=$(tc-getCC) \
		--host-cc=$(tc-getBUILD_CC) \
		--prefix=/usr \
		--confdir=/etc/mplayer \
		--datadir=/usr/share/mplayer \
		--libdir=/usr/$(get_libdir) \
		--enable-menu \
		--enable-network \
		--disable-tv-bsdbt848 \
		--disable-tremor \
	"
	################
	#Optional features#
	###############
	if use cpudetection || use bindist; then
		my_conf="${my_conf} --enable-runtime-cpudetection"
	fi

	enable_extension_disable fribidi bidi

	enable_extension_disable enca enca

	enable_extension_disable cdparanoia cdparanoia
	enable_extension_disable libcdio cdio
	enable_extension_disable cddb cddb

	if use external-ffmpeg; then
	# use shared ffmpeg libs (not supported),
	# except for avutil (actively not supported)
		for lib in avcodec avformat postproc; do
			my_conf="${my_conf} --disable-lib${lib}_a"
		done
	fi

	enable_extension_disable dvdnav dvdnav
	enable_extension_disable dvdread dvdread
	if use dvdread; then
		my_conf="${my_conf} --disable-dvdread-internal --disable-libdvdcss-internal"
	fi

	enable_extension_disable mencoder encode
	enable_extension_disable libdv dv
	enable_extension_disable x264 x264
	my_conf="${my_conf} --disable-x264-lavc"
	enable_extension_disable twolame twolame
	enable_extension_disable faac aac
	my_conf="${my_conf} --disable-faac-lavc"
	enable_extension_disable mp3lame mp3
	my_conf="${my_conf} --disable-mp3lame-lavc"

	enable_extension_disable x11 X
	enable_extension_disable vm X
	enable_extension_enable gui gtk
	enable_extension_disable xinerama xinerama
	enable_extension_disable xv xv

	enable_extension_disable dga2 dga

	enable_extension_disable png png
	enable_extension_disable inet6 ipv6
	enable_extension_enable joystick joystick
	enable_extension_disable lirc lirc
	enable_extension_disable live live
	enable_extension_disable rtc rtc
	enable_extension_disable smb samba
	enable_extension_disable bitmap-font bitmap-fonts
	enable_extension_disable freetype truetype
	enable_extension_disable fontconfig fontconfig
	enable_extension_disable ass srt
	if use !v4l && use !v4l2; then
		my_conf="${my_conf} --disable-tv"
	else
		enable_extension_disable tv-v4l1 v4l
		enable_extension_disable tv-v4l2 v4l2
	fi
	enable_extension_enable radio radio
	enable_extension_enable radio-capture radio
	enable_extension_disable radio-v4l v4l
	enable_extension_disable radio-v4l2 v4l2

	#######
	# Codecs #
	#######
	enable_extension_disable gif gif
	enable_extension_disable jpeg jpeg
	enable_extension_disable ladspa ladspa
	enable_extension_disable libdca dts
	enable_extension_disable liblzo lzo
	enable_extension_disable musepack musepack
	if use aac; then
		use external-faad && my_conf="${my_conf} --disable-faad-internal"
	else
		my_conf="${my_conf} --disable-faad-internal --disable-faad"
	fi
	enable_extension_disable libvorbis vorbis
	enable_extension_disable theora theora
	enable_extension_disable speex speex
	enable_extension_disable xvid xvid
	my_conf="${my_conf} --disable-xvid-lavc"
	enable_extension_disable real real
	if use real && use x86; then
		my_conf="${my_conf} --realcodecsdir=/opt/RealPlayer/codecs"
	elif use real && use amd64; then
		my_conf="${my_conf} --realcodecsdir=/usr/$(get_libdir)/codecs"
	fi
	enable_extension_disable win32dll win32codecs
	enable_extension_disable libamr_nb amr
	enable_extension_disable libamr_wb amr
	enable_extension_disable libdirac-lavc dirac
	enable_extension_disable libschroedinger-lavc schroedinger

	#############
	# Video Output #
	#############
	enable_extension_disable dvbhead dvb
	use dvb && my_conf="${my_conf} --with-dvbincdir=/usr/include"

	enable_extension_disable aa aalib
	enable_extension_disable directfb directfb
	enable_extension_disable fbdev fbcon
	use fbcon && enable_extension_disable s3fb video_cards_s3virge
	enable_extension_disable ggi ggi
	enable_extension_disable caca libcaca
	enable_extension_disable gl opengl
	enable_extension_disable vesa video_cards_vesa
	enable_extension_disable sdl sdl

	enable_extension_disable svga svga
	enable_extension_disable svgalib_helper svga
	enable_extension_disable vidix vidix
	enable_extension_disable vidix-pcidb vidix
	enable_extension_disable zr zoran

	enable_extension_disable tga tga

	enable_extension_disable xv xv
	if use xvmc; then
		my_conf="${my_conf} --enable-xvmc --with-xvmclib=XvMCW"
	else
		my_conf="${my_conf} --disable-xvmc"
	fi

	enable_extension_disable mga video_cards_mga
	use X && enable_extension_disable xmga video_cards_mga

	enable_extension_enable tdfxvid video_cards_tdfx
	enable_extension_enable 3dfx video_cards_tdfx
	use fbcon && enable_extension_enable tdfxfb video_cards_tdfx

	#############
	# Audio Output #
	#############
	enable_extension_disable alsa alsa
	enable_extension_disable jack jack
	enable_extension_disable arts arts
	enable_extension_disable esd esd
	enable_extension_disable mad mad
	enable_extension_disable nas nas
	enable_extension_disable openal openal
	enable_extension_disable ossaudio oss
	enable_extension_disable pulse pulseaudio

	#################
	# Advanced Options #
	#################
	enable_extension_disable 3dnow 3dnow
	enable_extension_disable 3dnowext 3dnowext
	enable_extension_disable sse sse
	enable_extension_disable sse2 sse2
	enable_extension_disable ssse3 ssse3
	enable_extension_disable mmx mmx
	enable_extension_disable mmxext mmxext
	use debug && my_conf="${my_conf} --enable-debug=3"

	if use xanim
	then
		my_conf="${my_conf} --with-xanimlibdir=/usr/lib/xanim/mods"
	fi

	enable_extension_enable bl bl

	if use custom-cflags; then
	# ugly optimizations cause MPlayer to cry on x86 systems!
		if use x86 ; then
			replace-flags -O* -O2
			filter-flags -fPIC -fPIE
			use debug || append-flags -fomit-frame-pointer
		fi
		append-flags -D__STDC_LIMIT_MACROS
	else
		unset CFLAGS CXXFLAGS
	fi

	./configure ${my_conf} || die


	emake DEPS='' codecs.conf.h version.h || die "Failed to build MPlayer!"
	emake DEPS='' || die "Failed to build MPlayer!!"
	use doc && make -C ${S}/DOCS/xml html-chunked-en
}

src_install() {

	emake DEPS='' \
		prefix=${D}/usr \
		BINDIR=${D}/usr/bin \
		LIBDIR=${D}/usr/$(get_libdir) \
		CONFDIR=${D}/usr/share/mplayer \
		DATADIR=${D}/usr/share/mplayer \
		MANDIR=${D}/usr/share/man \
		INSTALLSTRIP='' \
		LDCONFIG=/bin/true \
		install || die "Failed to install MPlayer!"

	dodoc AUTHORS ChangeLog README
	# Install the documentation; DOCS is all mixed up not just html
	if use doc ; then
		dohtml -r "${S}"/DOCS/HTML/en/*
		cp -r "${S}/DOCS/tech" "${D}/usr/share/doc/${PF}/"
	fi
	if use examples ; then
		# Copy misc tools to documentation path, as they're not installed directly
		# and yes, we are nuking the +x bit.
		find "${S}/TOOLS" -type d | xargs -- chmod 0755
		find "${S}/TOOLS" -type f | xargs -- chmod 0644
		cp -r "${S}/TOOLS" "${D}/usr/share/doc/${PF}/" || die
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

	if [[ -d ${ROOT}${SKINDIR}default ]]; then
		rm -rf ${ROOT}${SKINDIR}default
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

