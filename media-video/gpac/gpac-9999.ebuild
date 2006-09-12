# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit wxwidgets cvs flag-o-matic nsplugins

DESCRIPTION="GPAC is an implementation of the MPEG-4 Systems standard developed from scratch in ANSI C."
HOMEPAGE="http://gpac.sourceforge.net/"
NBV="610"
WBV="600"
SRC_URI="amr? ( http://www.3gpp.org/ftp/Specs/archive/26_series/26.104/26104-${NBV}.zip
		http://www.3gpp.org/ftp/Specs/archive/26_series/26.204/26204-${WBV}.zip )"
ECVS_SERVER="gpac.cvs.sourceforge.net:/cvsroot/gpac"
ECVS_MODULE="gpac"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac amr debug ffmpeg jpeg mad mozilla nsplugin vorbis oss png sdl theora
truetype wxwindows xml xvid unicode X ssl"
S="${WORKDIR}/${PN/-cvs}"

RDEPEND="jpeg? ( media-libs/jpeg )
	mad? ( media-libs/libmad )
	mozilla? ( dev-lang/spidermonkey )
	nsplugin? ( net-libs/gecko-sdk )
	aac? ( media-libs/faad2 )
	ffmpeg? || ( media-video/ffmpeg-svn media-video/ffmpeg )
	vorbis? ( media-libs/libvorbis )
	theora? ( media-libs/libtheora )
	png? ( media-libs/libpng )
	truetype? ( >=media-libs/freetype-2.1 )
	sdl? ( media-libs/libsdl )
	wxwindows? ( >=x11-libs/wxGTK-2.5.2 )
	ssl? ( dev-libs/openssl )
	X? ( virtual/x11 )
	xml? ( >=dev-libs/libxml2-2.6.0 )
	xvid? ( >=media-libs/xvid-1.0.1 )
	>=dev-libs/libxml2-2.6.0"


DEPEND="${RDEPEND}
	amr? ( app-arch/unzip )"

src_unpack() {
	cvs_src_unpack
	cd ${WORKDIR}
	unpack ${A}
	cd ${S}
	chmod 755 configure

	if use wxwindows; then
		WX_GTK_VER="2.6"
		if use unicode; then
			need-wxwidgets unicode
		else
			need-wxwidgets gtk2
		fi
		sed -i "s:wx-config:${WX_CONFIG}:g" configure
	fi

	# make configure to pick theora, if presented
	use theora && sed -i 's:ltheora 2:ltheora -logg 2:' configure
	# skip stripping
	sed -i 's:\$(STRIP):touch:; s:\(INSTFLAGS=\).*:\1:' Makefile

	sed -i '/#include/s/\\/\//g' modules/svg_loader/svg_parser.c

	use sdl || sed -i 's:^has_sdl=yes:has_sdl=no:' configure
	use nsplugin || sed -i 's:osmozilla::' applications/Makefile
	use X || sed -i 's:PLUGDIRS+=x11_out:PLUGDIRS+=:' modules/Makefile

	epatch ${FILESDIR}/${PN}-*.diff

	if use amr; then
		cd modules/amr_float_dec
		unzip -jaq ${WORKDIR}/26104-${NBV}_ANSI_C_source_code.zip -d amr_nb_ft
		unzip -jaq ${WORKDIR}/26204-${WBV}_ANSI-C_source_code.zip -d amr_wb_ft
	fi
}

src_compile() {
	append-flags -fno-strict-aliasing

	local myconf
	use mozilla || myconf="${myconf} --use-js=no"
	use truetype || myconf="${myconf} --use-ft=no"
	use jpeg || myconf="${myconf} --use-jpeg=no"
	use png || myconf="${myconf} --use-png=no"
	use aac || myconf="${myconf} --use-faad=no"
	use mad || myconf="${myconf} --use-mad=no"
	use xvid || myconf="${myconf} --use-xvid=no"
	use ffmpeg || myconf="${myconf} --use-ffmpeg=no"

	./configure \
		--prefix=/usr \
		--mozdir=${D}usr/$(get_libdir)/${PLUGINS_DIR} \
		$(use_enable amr) \
		$(use_enable xml svg) \
		$(use_enable ssl) \
		$(use_enable debug) \
		$(use_enable oss oss-audio) \
		${myconf} || die

	# install to image dir
	sed -i "s:=/usr:=${D}usr:" config.mak
	# skip building generators dir (ifeq-ed in applications/Makefile)
	sed -i "/SRC_LOCAL_PATH/d" config.mak

	make OPTFLAGS="${CFLAGS} -fPIC -DPIC" lib mods || die
	make OPTFLAGS="${CFLAGS} -DGPAC_MODULES_PATH=\\\"/usr/$(get_libdir)/gpac\\\"" \
		apps || die
}

src_install() {
	make OPTFLAGS="${CFLAGS}" install || die

	dodoc AUTHORS BUGS Changelog INSTALL README TODO
	dodoc doc/*.{txt,bt} doc/CODING_STYLE doc/SceneGenerators
	dohtml doc/*.html
	insinto /usr/include/gpac
	doins include/gpac/*.h
}
