# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools subversion

DESCRIPTION="Musepack decoder library"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/trunk"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_compile() {
	emake -C libmpcdec || die
}

src_install() {
	einstall -C libmpcdec || die
	einstall -C include || die
}
