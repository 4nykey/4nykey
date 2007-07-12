# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV="${PN}${PV}"
DESCRIPTION="Tcl/Tk Image formats"
HOMEPAGE="http://tkimg.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PV}.tar.bz2"
S="${WORKDIR}/${MY_PV}"

LICENSE="BWidget"
SLOT="0"
KEYWORDS="~x86"
IUSE="threads debug"

DEPEND="
	dev-lang/tk
"
RDEPEND="
	${DEPEND}
"

src_compile() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads) \
		|| die
	emake CFLAGS_OPTIMIZE= || die
}

src_install() {
#	emake DESTDIR=${D} install || die
	einstall || die
#	dodoc ANNOUNCE ChangeLog changes README
#	dohtml doc/html/*
}
