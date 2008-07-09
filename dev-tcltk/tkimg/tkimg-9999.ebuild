# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Tcl/Tk Image formats"
HOMEPAGE="http://tkimg.sf.net"
ESVN_REPO_URI="https://tkimg.svn.sourceforge.net/svnroot/tkimg/trunk"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="BWidget"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	dev-lang/tk
"
RDEPEND="
	${DEPEND}
"

src_compile() {
	econf || die
	emake CFLAGS_OPTIMIZE= || die
}

src_install() {
	einstall || die
	dodoc ANNOUNCE ChangeLog changes README
	dohtml doc/html/*
}
