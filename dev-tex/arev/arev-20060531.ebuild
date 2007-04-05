# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

SUPPLIER="public"
DESCRIPTION="LaTeX package for the Arev Sans font family"
HOMEPAGE="http://www.ctan.org/tex-archive/fonts/arev/"
SRC_URI="ftp://tug.ctan.org/pub/tex-archive/fonts/${PN}.zip"
S=${WORKDIR}/${PN}

LICENSE="BitstreamVera LPPL-1.3 GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND="dev-tex/bera"

src_install() {
	find tex fonts -type f -printf %h\\n | sort -u | while read dir; do
		cd ${S}/${dir}
		latex-package_src_doinstall styles fonts
	done
	insinto ${TEXMF}/fonts
	doins -r fonts/{map,enc} source
	dodoc README ChangeLog
	use doc && dodoc *.pdf
}

pkg_postinst() {
	latex-package_rehash
	updmap-sys --enable Map ${PN}.map
}

pkg_postrm() {
	updmap-sys --disable ${PN}.map
}

