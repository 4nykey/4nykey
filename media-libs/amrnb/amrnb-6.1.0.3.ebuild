# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MAJ=26
MIN=104
PAT=610
NBV="${MAJ}${MIN}-${PAT}"
DESCRIPTION="AMR NarrowBand codec wrapper library"
HOMEPAGE="http://www.3gpp.org http://www.penguin.cz/~utx/amr"
SRC_URI="
	http://ftp.penguin.cz/pub/users/utx/amr/${P}.tar.bz2
	http://www.3gpp.org/ftp/Specs/archive/${MAJ}_series/${MAJ}.${MIN}/${NBV}.zip
"

LICENSE="3GPP GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unpack ${A}
	mv ${NBV}_ANSI_C_source_code.zip ${S}
	cd ${S}
	sh ./prepare_sources.sh || die
	epatch "${FILESDIR}"/${PN}-makefile.patch
}

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README TODO
}
