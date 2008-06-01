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
FONT_SUFFIX="afm pfb"
use opentype && FONT_SUFFIX="otf"

src_install() {
	font_src_install
	if use gs; then
		use opentype && cat Fontmap.CMU.alias >> Fontmap.CMU
		doins Fontmap.CMU
		echo "GS_LIB=\"${FONTDIR}\"" > ${T}/16${PN}
		insinto /etc/env.d
		doins ${T}/16${PN}
	fi
}

pkg_postinst() {
	font_pkg_postinst
	if use gs; then
		elog "In order to use these fonts in ghostscript, add a line saying"
		elog "(Fontmap.CMU) .runlibfile"
		elog "to /usr/share/ghostscript/x.yz/lib/Fontmap, where 'x.yz' is"
		elog "ghostscript version"
	fi
}
