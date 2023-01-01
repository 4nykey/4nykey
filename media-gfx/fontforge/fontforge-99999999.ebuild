# Copyright 2004-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit python-single-r1 xdg cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	MY_PV="21d929b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="postscript font editor and converter"
HOMEPAGE="https://fontforge.org/"

LICENSE="BSD GPL-3+"
SLOT="0"
IUSE="doc truetype-debugger gif gtk jpeg png +python readline test tiff svg woff2 X"
IUSE+=" extras libspiro"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:2=
	>=media-libs/freetype-2.3.7:2=
	gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	gtk? ( >=x11-libs/gtk+-3.10:3 )
	!gtk? (
		X? (
			>=x11-libs/cairo-1.6:0=
			>=x11-libs/pango-1.10:0=[X]
			x11-libs/libX11:=
			x11-libs/libXi:=
		)
	)
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	woff2? ( media-libs/woff2:0= )
	libspiro? ( media-libs/libspiro )
"
DEPEND="${RDEPEND}
	!gtk? ( X? ( x11-base/xorg-proto ) )
"
RDEPEND+="
	media-fonts/cantarell
	|| (
		media-fonts/inconsolata
		media-fonts/inconsolata-hellenic
		media-fonts/inconsolata-lgc
	)
"
BDEPEND="
	sys-devel/gettext
	doc? ( >=dev-python/sphinx-2 )
	python? ( ${PYTHON_DEPS} )
	test? ( ${RDEPEND} )
"

pkg_setup() {
	:
}

src_prepare() {
	sed \
		-e '/\<\(Cantarell\|Inconsolata\)\>/d' \
		-e 's:OFL\.txt::' \
		-i fontforgeexe/pixmaps/*/CMakeLists.txt
	eapply -l "${FILESDIR}"/cmake-install_examples.diff
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(usex doc ON OFF)
		-DENABLE_LIBGIF=$(usex gif ON OFF)
		-DENABLE_LIBJPEG=$(usex jpeg ON OFF)
		-DENABLE_LIBPNG=$(usex png ON OFF)
		-DENABLE_LIBREADLINE=$(usex readline ON OFF)
		-DENABLE_LIBSPIRO=OFF # No package in Gentoo
		-DENABLE_LIBTIFF=$(usex tiff ON OFF)
		-DENABLE_MAINTAINER_TOOLS=OFF
		-DENABLE_PYTHON_EXTENSION=$(usex python ON OFF)
		-DENABLE_PYTHON_SCRIPTING=$(usex python ON OFF)
		-DENABLE_TILE_PATH=ON
		-DENABLE_WOFF2=$(usex woff2 ON OFF)
	)

	if use gtk || use X; then
		mycmakeargs+=(
			-DENABLE_GUI=ON
			# Prefer GTK over X11 if both USE flage are enabled
			-DENABLE_X11=$(usex gtk OFF ON)
		)
	else
		mycmakeargs+=( -DENABLE_GUI=OFF )
	fi

	if use python; then
		python_setup
		mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )
	fi

	if use truetype-debugger ; then
		local ft2="${ESYSROOT}/usr/include/freetype2"
		local ft2i="${ft2}/internal4fontforge"
		mycmakeargs+=(
			-DENABLE_FREETYPE_DEBUGGER="${ft2}"
			-DFreeTypeSource_INCLUDE_DIRS="${ft2};${ft2i}/include;${ft2i}/include/freetype;${ft2i}/src/truetype"
		)
	fi
	mycmakeargs+=(
		-DENABLE_LIBSPIRO=$(usex libspiro)
		-DENABLE_FONTFORGE_EXTRAS=$(usex extras)
	)

	cmake_src_configure
}
