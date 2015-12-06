# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VIRTUALX_REQUIRED="doc"
inherit virtualx qmake-utils autotools-utils
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
	DEPEND="
		sys-apps/help2man
	"
else
	SRC_URI="mirror://sourceforge/freetype/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for automated hinting of truetype fonts"
HOMEPAGE="http://www.freetype.org/ttfautohint/index.html"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0"
IUSE="qt4"
REQUIRED_USE="doc? ( qt4 )"

RDEPEND="
	media-libs/harfbuzz
	qt4? ( dev-qt/qtgui:4 )
"
DEPEND="
	${DEPEND}
	${RDEPEND}
	doc? (
		media-gfx/imagemagick
		media-gfx/inkscape
		app-text/pandoc
		dev-texlive/texlive-xetex
		media-fonts/freefont
		media-fonts/pothana2k
	)
"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
PATCHES=( "${FILESDIR}"/${PN}*.diff )

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
	ebegin "Running bootstrap"
	AUTORECONF=true \
		./bootstrap --force --gnulib-srcdir="${S}/.gnulib" >& \
		"${T}"/bootstrap.log
	eend $? || die "bootstrap failed, check ${T}/bootstrap.log"
	fi
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with doc)
		$(use_with qt4 qt $(qt4_get_bindir))
	)
	if use doc; then
		Xeconf "${myeconfargs[@]}"
	else
		autotools-utils_src_configure
	fi
}

src_compile() {
	if use doc; then
		Xemake
	else
		autotools-utils_src_compile
	fi
}

src_install() {
	autotools-utils_src_install \
		docdir="${EPREFIX}"/usr/share/doc/${PF}
}
