# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Musepack decoder library"
HOMEPAGE="http://www.musepack.net"
#SRC_URI="http://musepack.origean.net/files/source/${P}.tar.bz2"
ESVN_REPO_URI="http://svn.caddr.com/svn/libmpcdec/trunk"
ESVN_BOOTSTRAP="WANT_AUTOMAKE=1.6 ./autogen.sh"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="static"

src_compile() {
	econf `use_enable static` || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
