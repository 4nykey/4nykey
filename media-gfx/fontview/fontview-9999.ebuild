# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs wxwidgets
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=( )
else
	inherit vcs-snapshot
	MY_PV="4d6f3fd"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An app that shows the contents of a font file"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="gtk3"

RDEPEND="
	dev-libs/fribidi
	dev-libs/libraqm
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
		-e '/\(freetype\|fribidi\|harfbuzz\|raqm\|wxWidgets\|ucdn\)/d' \
		-i "${S}"/src/fontview/fontview.gyp
}

src_configure() {
	gyp \
		-f make --depth . \
		"${S}"/src/fontview/fontview.gyp || die
}

src_compile() {
	local _pc="$(tc-getPKG_CONFIG)" _d="fribidi freetype2 harfbuzz raqm"
	local myemakeargs=(
		LIBS="$(${WX_CONFIG} --libs) $(${_pc} --libs ${_d})"
		CPPFLAGS="$(${WX_CONFIG} --cppflags) $(${_pc} --cflags ${_d})"
		V=1
	)
	tc-env_build emake "${myemakeargs[@]}"
}

src_install() {
	dobin out/Default/${PN}
	einstalldocs
}
