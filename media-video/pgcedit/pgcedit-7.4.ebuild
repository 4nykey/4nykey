# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="The Swiss Army knife of DVD editing"
HOMEPAGE="http://www.videohelp.com/~r0lZ/pgcedit/"
SRC_URI="http://www.videohelp.com/~r0lZ/${PN}/versions/PgcEdit_source_${PV}.zip
	doc? ( http://www.videohelp.com/~r0lZ/${PN}/versions/PgcEdit_Manual_html.zip )"
RESTRICT="primaryuri"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=">=dev-lang/tk-8.4"

src_install() {
	local instdir="/opt/${PN}"

	touch ${T}/tmp
	echo -e '#!/bin/sh\n'${instdir}/PgcEdit.tcl > ${T}/tmp
	exeinto /usr/bin
	newexe ${T}/tmp ${PN}

	exeinto ${instdir}
	doexe PgcEdit.tcl

	find lib -type d |
		while read dir; do
			insinto ${instdir}/$dir
			find $dir -maxdepth 1 -type f -print0 | xargs -0 doins
		done
	dodir ${instdir}/plugins
	insinto ${instdir}/bin
	doins bin/*.tcl

	dodoc HISTORY.txt TODO.txt
	use doc && dohtml -r doc/
}
