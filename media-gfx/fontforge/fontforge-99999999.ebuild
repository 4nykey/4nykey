# Copyright 2004-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1 xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="ee08337"
	fi
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="postscript font editor and converter"
HOMEPAGE="https://fontforge.github.io/"

LICENSE="BSD GPL-3+"
SLOT="0"
IUSE="
extras gif gtk +gui jpeg libspiro png +python readline svg test tiff
truetype-debugger unicode woff2
"

RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

REQUIRED_USE="
	gtk? ( gui )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( png python )
"

DEPEND="
	>=media-libs/freetype-2.3.7:2=
	dev-libs/glib:2
	dev-libs/libxml2:2=
	gui? (
		gtk? ( >=x11-libs/gtk+-3.10:3 )
		!gtk? (
			x11-libs/libX11:0=
			x11-libs/libXi:0=
			>=x11-libs/pango-1.10:0=[X]
		)
	)
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	python? ( ${PYTHON_DEPS} )
	libspiro? ( media-libs/libspiro )
	unicode? ( media-libs/libuninameslist:0= )
	gif? ( media-libs/giflib:0= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	readline? ( sys-libs/readline:0= )
	tiff? ( media-libs/tiff:0= )
	woff2? ( media-libs/woff2 )
"
RDEPEND="
	${DEPEND}
	media-fonts/cantarell
	|| (
		media-fonts/inconsolata
		media-fonts/inconsolata-hellenic
		media-fonts/inconsolata-lgc
	)
"
BDEPEND="
	!gtk? ( x11-base/xorg-proto )
	sys-devel/gettext
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/20170731-gethex-unaligned.patch
	"${FILESDIR}"/${PN}-tilepath.diff
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed \
		-e '/\<\(Cantarell\|Inconsolata\)\>/d' \
		-e 's:OFL\.txt::' \
		-i fontforgeexe/pixmaps/*/CMakeLists.txt
	eapply -l "${FILESDIR}"/cmake-install_examples.diff
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=yes
		-DENABLE_GUI=$(usex gui)
		-DENABLE_X11=$(usex gui $(usex !gtk))
		-DENABLE_PYTHON_SCRIPTING=$(usex python)
		-DENABLE_PYTHON_EXTENSION=$(usex python)
		-DENABLE_LIBSPIRO=$(usex libspiro)
		-DENABLE_LIBUNINAMESLIST=$(usex unicode)
		-DENABLE_LIBGIF=$(usex gif)
		-DENABLE_LIBJPEG=$(usex jpeg)
		-DENABLE_LIBPNG=$(usex png)
		-DENABLE_LIBREADLINE=$(usex readline)
		-DENABLE_LIBTIFF=$(usex tiff)
		-DENABLE_WOFF2=$(usex woff2)
		-DENABLE_FONTFORGE_EXTRAS=$(usex extras)
		-DENABLE_TILE_PATH=yes
	)
	if use truetype-debugger; then
		local _i="${EROOT}/usr/include/freetype2/internal4fontforge"
		local _d="${_i}/include;${_i}/include/freetype;${_i}/src/truetype"
		mycmakeargs+=(
			-DENABLE_FREETYPE_DEBUGGER="${_i}"
			-DFreeTypeSource_INCLUDE_DIRS="${_d}"
		)
	fi
	cmake-utils_src_configure
}
