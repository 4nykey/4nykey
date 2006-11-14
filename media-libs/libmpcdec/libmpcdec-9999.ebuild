# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Musepack decoder library"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpcdec/trunk"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_unpack() {
	subversion_src_unpack
	cd ${S}
	sed -i "/^CFLAGS=/d" configure.ac
	eautoreconf
}

src_install() {
	einstall || die
	dodoc README
}
