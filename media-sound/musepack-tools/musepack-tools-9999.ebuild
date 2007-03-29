# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/branches/r2d"
ESVN_PATCHES="${P}-*.patch"

SLOT="8"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	>=dev-util/cmake-2.4
"

src_compile() {
	cmake . \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
