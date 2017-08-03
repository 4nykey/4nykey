# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
	EGIT_BRANCH="Tools3"
else
	inherit vcs-snapshot
	MY_PV="0c7dfb0"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools ltprune

DESCRIPTION="A font editing system derived from FontForge"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="gif jpeg nls static-libs tiff xi xkbui X"
REQUIRED_USE="
xi? ( X )
xkbui? ( X )
"

RDEPEND="
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff:0 )
	jpeg? ( virtual/jpeg:0 )
	X? (
		x11-libs/libX11
		x11-libs/cairo
		x11-libs/pango
		x11-libs/libXcursor
		xi? ( x11-libs/libXi )
		xkbui? ( x11-libs/libxkbui )
	)
	dev-libs/libunistring
	dev-libs/gmp:0
	sci-libs/gsl
	dev-libs/sortsmill-core
	dev-scheme/sortsmill-core-guile
	media-libs/libpng:0
	dev-libs/libxml2:2
	media-libs/freetype:2
	dev-libs/libunicodenames
"
DEPEND="
	${RDEPEND}
	dev-util/sortsmill-tig
	virtual/yacc
	sys-apps/help2man
	dev-util/intltool
	sys-devel/m4
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable X gui)
		$(use_with xi)
		$(use_with xkbui)
		$(use_with gif)
		$(use_with jpeg)
		$(use_with tiff)
		$(use_enable static-libs static)
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	prune_libtool_files
}
