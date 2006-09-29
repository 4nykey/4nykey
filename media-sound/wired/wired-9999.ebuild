# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools flag-o-matic

DESCRIPTION="A professional music production and creation software"
HOMEPAGE="http://wired.is.free.fr"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/wired/trunk/wired"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE="debug dssi nls soundtouch encode"

RDEPEND="
	>=x11-libs/wxGTK-2.6
	media-libs/alsa-lib
	>=media-libs/libsndfile-1.0
	soundtouch? ( >=media-libs/libsoundtouch-1.2.1 )
	dev-libs/libxml2
	media-libs/libsamplerate
	dssi? ( >=media-libs/dssi-0.9 )
	encode? ( media-libs/flac media-libs/libvorbis )
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

pkg_setup() {
	if ! built_with_use x11-libs/wxGTK X ; then
		die "x11-libs/wxGTK must be compiled with X support"
	fi
	append-flags -fno-strict-aliasing
}

src_unpack() {
	subversion_src_unpack
	cd ${S}

	# make --as-needed work
	epatch "${FILESDIR}"/${P}-automess.diff
	sed -i 's:\[FLAC++\]:[FLAC]:' configure.ac
	# make autoheader happy
	sed -i 's:\(PACKAGE_LOCALE_DIR,.*\)):\1, ""):' configure.ac
	# don't install portaudio
	sed -i "s:src/portaudio ::" Makefile.am

	autopoint --force || die
	AT_NO_RECURSIVE="yes" eautoreconf
}

src_compile() {
	# first build pa statically
	cd src/portaudio
	econf \
		--enable-static \
		--disable-shared \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with oss) \
		|| die
	emake lib/libportaudio.la || die

	cd ${S}
	econf \
		--disable-static \
		--disable-optimize \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_enable dssi) \
		$(use_enable soundtouch plugins) \
		$(use_enable encode codecs) \
		--enable-portaudio \
		--no-recursion \
		|| die

	emake CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	einstall MKINSTALLDIRS="${S}/config/mkinstalldirs" || die
	dodoc AUTHORS BUGS NEWS README TODO 
}
