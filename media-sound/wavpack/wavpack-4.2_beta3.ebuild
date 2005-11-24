# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="WavPack hybrid audio compression"
HOMEPAGE="http://www.wavpack.com/"
#SRC_URI="http://www.wavpack.com/${P}.tar.bz2"
ESVN_REPO_URI="http://svn.caddr.com/svn/${PN}/trunk"
#ESVN_BOOTSTRAP="./autogen.sh"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/ncurses"

src_unpack() {
	subversion_svn_fetch
	cd ${S}
	touch AUTHORS ChangeLog NEWS README
	einfo "Running autogen.sh"
	WANT_AUTOMAKE=1.7 ./autogen.sh > /dev/null || die
}

src_install() {
	einstall || die
	dodoc *.txt
}
