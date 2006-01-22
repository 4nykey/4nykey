# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit subversion autotools

DESCRIPTION="A library handling connection to a MPD server"
HOMEPAGE="http://www.musicpd.org"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="virtual/libc"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf || die
}

src_install() {
	einstall || die
	dodoc README ChangeLog
}
