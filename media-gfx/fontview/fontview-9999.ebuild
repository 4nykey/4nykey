# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-r1 toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=( src/third_party/gyp )
else
	MY_PV="2697f15"
	MY_GYP="gyp-e7079f0"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		https://chromium.googlesource.com/external/${MY_GYP%-*}/+archive/${MY_GYP##*-}.tar.gz
		-> ${MY_GYP}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="An app that shows the contents of a font file"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:3.0
	dev-libs/libraqm
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
"
PATCHES=( "${FILESDIR}" )

pkg_setup() {
	python_setup
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
		cd "${S}"/src/third_party/${MY_GYP%-*}
		unpack ${MY_GYP}.tar.gz
	fi
}

src_configure() {
	sh "${S}"/src/third_party/gyp/gyp -f make --depth . \
		src/fontview/fontview.gyp || die
}

src_compile() {
	emake \
		CXX=$(tc-getCXX) \
		LIBS="$(wx-config-3.0 --libs) \
			$(pkg-config --libs fribidi freetype2 harfbuzz raqm)" \
		CXXFLAGS="$(wx-config-3.0 --cppflags) \
			$(pkg-config --cflags fribidi freetype2 harfbuzz) -std=c++11" \
		V=1
}

src_install() {
	dobin out/Default/${PN}
	einstalldocs
}
