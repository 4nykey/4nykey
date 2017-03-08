# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 toolchain-funcs wxwidgets
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=(
		src/third_party/gyp
		src/third_party/raqm/libraqm
		src/third_party/ucdn/ucdn
	)
else
	MY_PV="a0581ed"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_G="gyp-e7079f0"
	MY_R="libraqm-59d68d5"
	MY_U="ucdn-6ca0116"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/bnoordhuis/${MY_G%-*}/tar.gz/${MY_G##*-} -> ${MY_G}.tar.gz
		mirror://githubcl/HOST-Oman/${MY_R%-*}/tar.gz/${MY_R##*-} -> ${MY_R}.tar.gz
		mirror://githubcl/grigorig/${MY_U%-*}/tar.gz/${MY_U##*-} -> ${MY_U}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An app that shows the contents of a font file"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="gtk3"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/fribidi
	media-libs/freetype:2
	media-libs/harfbuzz
	!gtk3? ( x11-libs/wxGTK:3.0 )
	gtk3? ( x11-libs/wxGTK:3.0-gtk3 )
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
"

pkg_setup() {
	python-any-r1_pkg_setup
	WX_GTK_VER=$(usex gtk3 3.0-gtk3 3.0)
	setup-wxwidgets
}

src_prepare() {
	default
	sed \
		-e '/\(freetype\|fribidi\|harfbuzz\|wxWidgets\)/d' \
		-i "${S}"/src/fontview/fontview.gyp "${S}"/src/third_party/raqm/raqm.gyp

	[[ -z ${PV%%*9999} ]] && return
	mv "${WORKDIR}"/${MY_G}/* "${S}"/src/third_party/gyp/
	mv "${WORKDIR}"/${MY_R}/* "${S}"/src/third_party/raqm/libraqm/
	mv "${WORKDIR}"/${MY_U}/* "${S}"/src/third_party/ucdn/ucdn/
}

src_configure() {
	${EPYTHON} "${S}"/src/third_party/gyp/gyp_main.py \
		-f make --depth . \
		"${S}"/src/fontview/fontview.gyp || die
}

src_compile() {
	local _pc="$(tc-getPKG_CONFIG)"
	emake \
		CXX=$(tc-getCXX) \
		CC=$(tc-getCC) \
		LIBS="$(${WX_CONFIG} --libs) \
			$(${_pc} --libs fribidi freetype2 harfbuzz)" \
		CPPFLAGS="$(${WX_CONFIG} --cppflags) \
			$(${_pc} --cflags fribidi freetype2 harfbuzz)" \
		V=1
}

src_install() {
	dobin out/Default/${PN}
	einstalldocs
}
