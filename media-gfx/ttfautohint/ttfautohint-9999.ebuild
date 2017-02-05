# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools qmake-utils
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

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && return
	eapply "${FILESDIR}"/${PN}-lessfonts.diff
	AUTORECONF=true \
	autotools_run_tool ./bootstrap --no-git --force --gnulib-srcdir=".gnulib"
	eautoreconf
	use doc && cp "${DISTDIR}"/ttfautohintGUI.png "${S}"/doc/img/
}

src_configure() {
	local _q="$(qt4_get_bindir)" \
	myeconfargs=(
		$(use_with doc)
		$(use_with qt4 qt)
	)
	QMAKE="${_q}/qmake" MOC="${_q}/moc" UIC="${_q}/uic" RCC="${_q}/rcc" \
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	emake ${PN}.1 $(usex qt4 ${PN}GUI.1 '') -C frontend
}

src_install() {
	default
	doman frontend/*.1
	local _d="${ED}/usr/share/doc/${PF}"
	if [[ -f "${_d}"/${PN}.html ]]; then
		cd "${_d}"
		mkdir -p html
		mv -f *.{js,html} img html/
	fi
}
