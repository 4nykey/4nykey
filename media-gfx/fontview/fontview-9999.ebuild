# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 toolchain-funcs wxwidgets
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
	EGIT_SUBMODULES=( src/third_party/gyp )
else
	MY_PV="2697f15"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_GYP="gyp-e7079f0"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		https://chromium.googlesource.com/external/${MY_GYP%-*}/+archive/${MY_GYP##*-}.tar.gz
		-> ${MY_GYP}.tar.gz
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
	!gtk3? ( x11-libs/wxGTK:3.0 )
	gtk3? ( x11-libs/wxGTK:3.0-gtk3 )
	dev-libs/libraqm
"
DEPEND="
	${DEPEND}
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
	sed -e "/'dependencies':/,/\]\,/d" -i src/fontview/fontview.gyp
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
		LIBS="$(${WX_CONFIG} --libs) \
			$(pkg-config --libs fribidi freetype2 harfbuzz raqm)" \
		CXXFLAGS="$(${WX_CONFIG} --cppflags) \
			$(pkg-config --cflags fribidi freetype2 harfbuzz)" \
		V=1
}

src_install() {
	dobin out/Default/${PN}
	einstalldocs
}
