# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit wxwidgets-nu cvs flag-o-matic nsplugins

DESCRIPTION="GPAC is an implementation of the MPEG-4 Systems standard developed from scratch in ANSI C."
HOMEPAGE="http://gpac.sourceforge.net/"
NBV="610"
WBV="600"
SRC_URI="
	amr? (
		http://www.3gpp.org/ftp/Specs/archive/26_series/26.104/26104-${NBV}.zip
		http://www.3gpp.org/ftp/Specs/archive/26_series/26.204/26204-${WBV}.zip
	)
"
ECVS_SERVER="gpac.cvs.sourceforge.net:/cvsroot/gpac"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
aac amr debug ffmpeg jpeg mad javascript nsplugin vorbis oss png sdl theora
truetype wxwindows xml xvid unicode X ssl firefox xulrunner seamonkey opengl
"

RDEPEND="
	jpeg? ( media-libs/jpeg )
	mad? ( media-libs/libmad )
	javascript? ( dev-lang/spidermonkey )
	aac? ( media-libs/faad2 )
	ffmpeg? ( media-video/ffmpeg )
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )
	png? ( media-libs/libpng )
	truetype? ( >=media-libs/freetype-2.1 )
	wxwindows? ( >=x11-libs/wxGTK-2.5.2 )
	ssl? ( dev-libs/openssl )
	xml? ( >=dev-libs/libxml2-2.6.0 )
	xvid? ( >=media-libs/xvid-1.0.1 )
	sdl? ( media-libs/libsdl )
	X? (
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libXext
	)
	nsplugin? (
		firefox? ( www-client/mozilla-firefox )
		!firefox? (
			xulrunner? ( net-libs/xulrunner )
			!xulrunner? (
				seamonkey? ( www-client/seamonkey )
			)
		)
	)
	opengl? ( virtual/opengl )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	amr? ( app-arch/unzip )
"

src_unpack() {
	cvs_src_unpack
	cd ${WORKDIR}
	use amr && unpack ${A}
	cd ${S}

	if use wxwindows; then
		WX_GTK_VER="2.6"
		if use unicode; then
			need-wxwidgets unicode
		else
			need-wxwidgets gtk2
		fi
		sed -i "s:wx-config:${WX_CONFIG}:g" configure
	fi

	epatch "${FILESDIR}"/${PN}-*.diff

	# skip stripping
	sed -i 's:\$(STRIP):touch:; s:\(INSTFLAGS=\).*:\1:' Makefile

	if use nsplugin; then
		if use firefox || use xulrunner || use seamonkey; then
			epatch "${FILESDIR}"/${PN}-ext_gecko.patch
		fi
	else
		sed -i 's:osmozilla::' applications/Makefile
	fi
	use X || sed -i 's:PLUGDIRS+=x11_out:PLUGDIRS+=:' modules/Makefile

	if use amr; then
		cd modules/amr_float_dec
		unzip -jaq ${WORKDIR}/26104-${NBV}_ANSI_C_source_code.zip -d amr_nb_ft
		unzip -jaq ${WORKDIR}/26204-${WBV}_ANSI-C_source_code.zip -d amr_wb_ft
	fi
}

teh_conf() {
	use $1 || myconf="${myconf} --use-${1}=no"
}

src_compile() {
	append-flags -fno-strict-aliasing

	for x in javascript truetype jpeg png aac mad xvid ffmpeg sdl vorbis theora
	do teh_conf $x
	done
	/bin/sh ./configure \
		--prefix=/usr \
		--mozdir=${D}usr/$(get_libdir)/${PLUGINS_DIR} \
		$(use_enable amr) \
		$(use_enable xml svg) \
		$(use_enable ssl) \
		$(use_enable debug) \
		$(use_enable oss oss-audio) \
		$(use_enable wxwindows wx) \
		$(use_enable opengl) \
		${myconf} || die

	# install to image dir
	sed -i "s:=/usr:=${D}usr:" config.mak
	# skip building generators dir (ifeq-ed in applications/Makefile)
	sed -i "/SRC_LOCAL_PATH/d" config.mak
	# set prefered gecko provider. gpac bundles one as well, and this will be
	# used if none of firefox, xulrunner or seamonkey is requested
	if use nsplugin && (use firefox || use xulrunner || use seamonkey); then
		if use firefox; then
			MOZCFG="/usr/lib/mozilla-firefox/firefox-config"
		elif use xulrunner; then
			MOZCFG="/usr/bin/xulrunner-config"
		else
			MOZCFG="/usr/lib/seamonkey/seamonkey-config"
		fi
		echo "MOZILLA_INC=$(${MOZCFG} --cflags plugin xpcom java)" >> config.mak
	fi

	make OPTFLAGS="${CFLAGS} -fPIC -DPIC" lib mods || die
	make \
	OPTFLAGS="${CFLAGS} -DGPAC_MODULES_PATH=\\\"/usr/$(get_libdir)/gpac\\\"" \
		apps || die
}

src_install() {
	make OPTFLAGS="${CFLAGS}" install || die

	dodoc AUTHORS BUGS Changelog README TODO
	insinto /usr/include/gpac
	doins include/gpac/*.h
}
