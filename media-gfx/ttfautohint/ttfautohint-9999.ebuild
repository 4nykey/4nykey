# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils
if [[ ${PV} == *9999* ]]; then
	VIRTUALX_REQUIRED="doc"
	inherit virtualx git-r3
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
	AUTOTOOLS_AUTORECONF="1"
	AUTOTOOLS_IN_SOURCE_BUILD="1"
	DEPEND="
		doc? (
			media-gfx/imagemagick
			media-gfx/inkscape
			app-text/pandoc
			dev-texlive/texlive-xetex
			media-fonts/freefont
			media-fonts/pothana2k
		)
	"
	REQUIRED_USE="doc? ( qt4 )"
else
	SRC_URI="mirror://sourceforge/freetype/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for automated hinting of truetype fonts"
HOMEPAGE="http://www.freetype.org/ttfautohint/index.html"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0"
IUSE="doc qt4"

RDEPEND="
	media-libs/harfbuzz
	qt4? ( dev-qt/qtgui:4 )
"
DEPEND="
	${DEPEND}
	${RDEPEND}
"

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
		$(use_with qt4 qt)
	)
	if [[ ${PV} == *9999* ]]; then
		Xeconf "${myeconfargs[@]}"
	else
		autotools-utils_src_configure
	fi
}

src_compile() {
	if [[ ${PV} == *9999* ]]; then
		Xemake
	else
		autotools-utils_src_compile
	fi
}

src_install() {
	autotools-utils_src_install \
		docdir="${EPREFIX}"/usr/share/doc/${PF}
}
