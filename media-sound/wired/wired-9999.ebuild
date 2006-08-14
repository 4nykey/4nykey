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
IUSE="debug dssi nls"

RDEPEND=">=x11-libs/wxGTK-2.6
	media-libs/alsa-lib
	>=media-libs/libsndfile-1.0
	>=media-libs/libsoundtouch-1.2.1
	dev-libs/libxml2
	media-libs/libsamplerate
	>=media-libs/portaudio-19
	dssi? ( >=media-libs/dssi-0.9 )"

DEPEND="${RDEPEND}"

pkg_setup() {
	if ! built_with_use x11-libs/wxGTK X ; then
		die "x11-libs/wxGTK MUST be compiled with X support"
	fi
}

src_unpack() {
	subversion_src_unpack
	cd ${S}
	# make --as-needed work
	epatch "${FILESDIR}/${P}-automess.diff"
	# hardcode portaudio header path
	grep -rl "portaudio\.h" . |
		xargs sed -i "s:\(portaudio\.h\):portaudio19/\1:"
	# make autoheader happy
	sed -i 's:\(PACKAGE_LOCALE_DIR,.*\)):\1, ""):' configure.ac
	# fix nls
	sed -i 's:use-libtool:external:; s:intl/Makefile::' configure.ac
	sed -i 's:intl ::' Makefile.am
	eautoreconf
	append-flags -fno-strict-aliasing
}

src_compile() {
	econf \
		--disable-static \
		--disable-optimize \
		--disable-nls \
	    $(use_enable debug) \
	    $(use_enable dssi) || die

	emake CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	emake install DESTDIR=${D} || die "Install failed"
	dodoc AUTHORS BUGS NEWS README TODO 
}
