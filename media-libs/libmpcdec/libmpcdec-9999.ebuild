# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Musepack decoder library"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpcdec/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	einstall || die
	dodoc README
}
