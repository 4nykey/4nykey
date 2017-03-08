# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=(
		cairo
		gyp
		src/third_party/dtl/dtl
	)
else
	inherit vcs-snapshot
	MY_PV="b083be9"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_G="gyp-697933c"
	MY_D="dtl-33a68d8"
	MY_C="cairo-1.15.4"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/bnoordhuis/${MY_G%-*}/tar.gz/${MY_G##*-}
		-> ${MY_G}.tar.gz
		mirror://githubcl/cubicdaiya/${MY_D%-*}/tar.gz/${MY_D##*-}
		-> ${MY_D}.tar.gz
		http://cairographics.org/snapshots/${MY_C}.tar.xz
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
	media-libs/freetype:2
	media-libs/harfbuzz[icu]
	dev-libs/expat
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_G}/* "${S}"/src/third_party/gyp
		mv "${WORKDIR}"/${MY_D}/* "${S}"/src/third_party/dtl/dtl
		mv "${WORKDIR}"/${MY_C}/* "${S}"/src/third_party/cairo/cairo
	fi
	sed \
		-e '/\/\(freetype\|icu\|expat\|harfbuzz\|pixman\)/d' \
		-i "${S}"/src/{fontdiff/fontdiff,third_party/cairo/cairo}.gyp || die
}

src_configure() {
	${EPYTHON} "${S}"/src/third_party/gyp/gyp_main.py \
		-f make --depth . \
		"${S}"/src/fontdiff/fontdiff.gyp || die
}

src_compile() {
	local _pc="$(tc-getPKG_CONFIG)" \
		_d="expat freetype2 harfbuzz-icu icu-uc pixman-1 zlib"
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
