# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
	DEPEND="
		sys-apps/help2man
		doc? (
			media-gfx/inkscape
			app-text/pandoc
			virtual/latex-base
			media-fonts/noto
			media-fonts/freefont
		)
	"
	SRC_URI="
		doc? ( https://www.freetype.org/ttfautohint/doc/img/ttfautohintGUI.png )
	"
else
	SRC_URI="mirror://sourceforge/freetype/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for automated hinting of truetype fonts"
HOMEPAGE="http://www.freetype.org/ttfautohint/index.html"

LICENSE="|| ( FTL GPL-2+ )"
SLOT="0"
IUSE="doc qt4"
REQUIRED_USE="doc? ( qt4 )"

RDEPEND="
	media-libs/harfbuzz
	qt4? ( dev-qt/qtgui:4 )
"
DEPEND+="
	${RDEPEND}
"

pkg_setup() {
	use doc || return
	HTML_DOCS=( doc/${PN}.html doc/img )
	DOCS=( doc/${PN}.pdf )
	PATCHES=( "${FILESDIR}"/${PN}-lessfonts.diff )
}

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && return
	AUTORECONF=true autotools_run_tool ./bootstrap \
		--no-git --no-bootstrap-sync --force --gnulib-srcdir=".gnulib"
	eautoreconf
	use doc && cp "${DISTDIR}"/ttfautohintGUI.png "${S}"/doc/img/
}

src_configure() {
	local myeconfargs=(
		$(use_with doc)
		$(use_with qt4 qt)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	emake -C frontend ${PN}.1 $(usex qt4 ${PN}GUI.1)
}

src_install() {
	default
	doman frontend/*.1
}
