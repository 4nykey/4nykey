# Copyright 2004-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
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
IUSE="doc truetype-debugger gif gtk harfbuzz jpeg png +python readline test tiff svg woff2"
IUSE+=" extras libspiro"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.67:2
	dev-libs/libltdl:0
	dev-libs/libxml2:2=
	>=media-libs/freetype-2.3.7:2=
	gif? ( media-libs/giflib:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	tiff? ( media-libs/tiff:= )
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	gtk? ( >=x11-libs/gtk+-3.10:3 )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	woff2? ( media-libs/woff2:0= )
	libspiro? ( media-libs/libspiro )
	harfbuzz? ( media-libs/harfbuzz:= )
"
DEPEND="
	${RDEPEND}
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
	use python && python-single-r1_pkg_setup
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
		-DENABLE_DOCS=$(usex doc)
		-DENABLE_LIBGIF=$(usex gif)
		-DENABLE_LIBJPEG=$(usex jpeg)
		-DENABLE_LIBPNG=$(usex png)
		-DENABLE_LIBREADLINE=$(usex readline)
		-DENABLE_LIBSPIRO=$(usex libspiro)
		-DENABLE_LIBTIFF=$(usex tiff)
		-DENABLE_MAINTAINER_TOOLS=no
		-DENABLE_PYTHON_EXTENSION=$(usex python)
		-DENABLE_PYTHON_SCRIPTING=$(usex python)
		-DENABLE_TILE_PATH=yes
		-DENABLE_WOFF2=$(usex woff2)
		-DENABLE_GUI=$(usex gtk)
		-DENABLE_HARFBUZZ=$(usex harfbuzz)
	)

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
