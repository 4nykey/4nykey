# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An automatic keyboard layout switcher"
HOMEPAGE="http://xneur.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

DEPEND="
	x11-libs/libXmu
"
DEPEND="
	${RDEPEND}
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

src_install () {
	einstall || die
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO .xneur/*
}
