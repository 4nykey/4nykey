# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://cm-unicode.sourceforge.net"
SRC_URI="
	!opentype? ( mirror://sourceforge/${PN}/${P}-pfb.tar.gz )
	opentype? ( mirror://sourceforge/${PN}/${P}-otf.tar.gz )
"

LICENSE="X11"
SLOT="0"
KEYWORDS="~x86"
IUSE="gs opentype"

DEPEND=""
RDEPEND="
	gs? ( virtual/ghostscript )
"

DOCS="Changes FAQ LICENSE README TODO"
FONT_S="${S}"

pkg_setup() {
	font_pkg_setup
	if use opentype; then
		FONT_SUFFIX="otf"
	else
		FONT_SUFFIX="afm pfb"
	fi
}

src_install() {
	font_src_install
	if use gs; then
		use opentype && cat Fontmap.CMU.alias >> Fontmap.CMU
		insinto /usr/share/doc/${PF}
		doins Fontmap.CMU
		dodir /etc/env.d
		echo "GS_LIB=${FONTDIR}:\$GS_LIB" > ${D}/etc/env.d/16${PN}
	fi
}

pkg_postinst() {
	font_pkg_postinst
	if use gs; then
		elog "In order to use these fonts in ghostscript, copy"
		elog "/usr/share/doc/${PF}/Fontmap.CMU to /usr/share/ghostscript/X.YZ/lib"
		elog "(where 'X.YZ' is ghostscript version) and add a line saying"
		elog "'(Fontmap.CMU) .runlibfile' to /usr/share/ghostscript/X.YZ/Fontmap."
	fi
}
