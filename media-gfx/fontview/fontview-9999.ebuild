# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs wxwidgets
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=(
		src/third_party/raqm/libraqm
	)
else
	MY_PV="a0581ed"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_R="libraqm-59d68d5"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/HOST-Oman/${MY_R%-*}/tar.gz/${MY_R##*-} -> ${MY_R}.tar.gz
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

RDEPEND="
	dev-libs/fribidi
	media-libs/freetype:2
	media-libs/harfbuzz
	!gtk3? ( x11-libs/wxGTK:3.0 )
	gtk3? ( x11-libs/wxGTK:3.0-gtk3 )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-util/gyp
"

pkg_setup() {
	WX_GTK_VER=$(usex gtk3 3.0-gtk3 3.0)
	setup-wxwidgets
}

src_prepare() {
	default
	sed \
		-e '/\(freetype\|fribidi\|harfbuzz\|wxWidgets\|ucdn\)/d' \
		-i "${S}"/src/fontview/fontview.gyp "${S}"/src/third_party/raqm/raqm.gyp

	[[ -z ${PV%%*9999} ]] && return
	mv "${WORKDIR}"/${MY_R}/* "${S}"/src/third_party/raqm/libraqm/
}

src_configure() {
	gyp \
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
