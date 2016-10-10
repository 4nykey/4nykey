# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="296ed30"
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools python-single-r1

DESCRIPTION="A font editing system derived from FontForge"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="editor gif jpeg legacy nls python tiff truetype-debugger unicode"
REQUIRED_USE="truetype-debugger? ( editor )"

DEPEND="
	dev-util/sortsmill-tig
	dev-scheme/sortsmill-core-guile
	dev-libs/sortsmill-core
	dev-libs/gmp:0
	sci-libs/gsl
	sys-libs/zlib
	media-libs/freetype:2
	editor? (
		x11-libs/cairo
		x11-libs/pango
		x11-libs/libXcursor
	)
	dev-libs/libunistring
	python? (
		${PYTHON_DEPS}
		dev-python/gmpy:0[${PYTHON_USEDEP}]
	)
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff:0 )
	jpeg? ( virtual/jpeg:0 )
	unicode? ( dev-libs/libunicodenames )
"
RDEPEND="
	${DEPEND}
"
DEPEND="
	${DEPEND}
	dev-util/intltool
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable editor programs)
		$(use_enable python python-api)
		--disable-python-compatibility
		$(use_enable legacy legacy-sortsmill-tools)
		$(use_enable truetype-debugger freetype-debugger)
		--enable-tile-path
		$(use_with gif giflib)
		$(use_with jpeg libjpeg)
		$(use_with tiff libtiff)
		$(use_with unicode libunicodenames)
	)
	FREETYPE_SOURCE=$(usex truetype-debugger \
		"${EPREFIX}/usr/include/freetype2/internal4fontforge" "") \
		econf "${myeconfargs[@]}"
}

src_prepare() {
	default
	rm -f "${S}"/m4/glib-gettext.m4
	sed -e '/fontforge\.xml\.in/d' \
		-i "${S}"/data/Makefile.am
	eautoreconf
}
