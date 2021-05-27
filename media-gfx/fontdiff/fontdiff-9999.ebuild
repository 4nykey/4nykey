# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=(
		src/third_party/dtl/dtl
	)
else
	MY_PV="b083be9"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_D="dtl-33a68d8"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/cubicdaiya/${MY_D%-*}/tar.gz/${MY_D##*-}
		-> ${MY_D}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A tool for finding visual differences between two font versions"
HOMEPAGE="https://github.com/googlei18n/fontdiff"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/fribidi
	>=media-libs/freetype-2.9:2
	>=media-libs/harfbuzz-1.7.4[icu]
	dev-libs/icu:=
	x11-libs/cairo
	dev-libs/expat
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-util/gyp
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-cairo114.diff
		"${FILESDIR}"/${PN}-hbicu.diff
	)
	default
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_D}/* "${S}"/src/third_party/dtl/dtl
	fi
	sed \
		-e '/\/\(freetype\|icu\|cairo\|expat\|harfbuzz\)/d' \
		-i "${S}"/src/fontdiff/fontdiff.gyp || die
}

src_configure() {
	gyp \
		-f make --depth . \
		"${S}"/src/fontdiff/fontdiff.gyp || die
}

src_compile() {
	local _pc="$(tc-getPKG_CONFIG)" \
		_d="cairo expat freetype2 harfbuzz-icu icu-uc"
	emake \
		CXX=$(tc-getCXX) \
		CC=$(tc-getCC) \
		AR=$(tc-getAR) \
		LIBS="$(${_pc} --libs ${_d})" \
		CPPFLAGS="$(${_pc} --cflags ${_d})" \
		V=1
}

src_install() {
	dobin "${S}"/out/Default/${PN}
	einstalldocs
}
