# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The Swiss Army knife of DVD editing"
HOMEPAGE="http://www.videohelp.com/~r0lZ/pgcedit/"
SRC_URI="
	http://www.videohelp.com/~r0lZ/${PN}/versions/PgcEdit_source_${PV}.zip
	doc? ( http://www.videohelp.com/~r0lZ/${PN}/versions/PgcEdit_Manual_html.zip )
"
RESTRICT="primaryuri"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc wine"

DEPEND="app-arch/unzip"
RDEPEND="
	>=dev-lang/tk-8.4
	wine? ( app-emulation/wine )
"

src_install() {
	local instdir="/opt/${PN}"

	cat << EOF > ${T}/${PN}
#!/bin/sh
/usr/bin/wish ${instdir}/PgcEdit.tcl
EOF
	dobin ${T}/${PN}

	exeinto ${instdir}
	doexe PgcEdit.tcl

	dodir ${instdir}/plugins
	keepdir ${instdir}/plugins
	insinto ${instdir}
	doins -r lib
	insinto ${instdir}/bin
	doins bin/*.tcl
	use wine && doins bin/PgcEditPreview.exe

	dodoc HISTORY.txt TODO.txt
	use doc && dohtml -r doc/*
}
