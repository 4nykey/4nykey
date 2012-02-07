# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/fprint_demo/fprint_demo-0.4.ebuild,v 1.1 2010/10/17 22:05:03 xmw Exp $

EAPI=4

inherit autotools git-2

DESCRIPTION="a simple GTK+ application to demonstrate and test libfprint's capabilities"
HOMEPAGE="http://www.reactivated.net/fprint/wiki/Fprint_demo"
EGIT_REPO_URI="git://github.com/dsd/fprint_demo.git"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-auth/libfprint
	x11-libs/gtk+:2
"

DEPEND="
	${RDEPEND}
"

src_install() {
	#emake DESTDIR="${D}" install || die
	einstall
	dodoc AUTHORS NEWS README
}
