# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="b8f4b51"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An app that shows the contents of a font file"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/fribidi
	dev-libs/libraqm
	media-libs/freetype:2
	media-libs/harfbuzz
	x11-libs/wxGTK:=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-build/gyp
"

pkg_setup() {
	local _w=( 3 3.0-gtk3 )
	has_version x11-libs/wxGTK:3.2 && _w=( 3 3.2 )
	_w="gtk${_w[0]}-unicode-${_w[1]}"
	WX_CONFIG="${EPREFIX}/usr/$(get_libdir)/wx/config/${_w}"
	einfo "Using wxWidgets:            ${_w}"
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
