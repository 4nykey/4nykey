# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

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
KEYWORDS="~x86 ~amd64"
IUSE="doc wine"

DEPEND="app-arch/unzip"
RDEPEND="
	>=dev-lang/tk-8.4
	wine? ( app-emulation/wine )
"

src_install() {
	local instdir="/opt/${PN}"

	insinto ${instdir}
	doins *.tcl
	doins -r lib
	insinto ${instdir}/bin
	doins bin/*.tcl
	use wine && doins bin/PgcEditPreview.exe
	dodir ${instdir}/plugins
	keepdir ${instdir}/plugins

	make_wrapper ${PN} "/usr/bin/wish ${instdir}/PgcEdit_main.tcl"

	dodoc HISTORY.txt TODO.txt
	use doc && dohtml -r doc/*
}
