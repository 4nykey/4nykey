# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="mpc123 - Musepack Console audio player"
HOMEPAGE="http://mpc123.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	media-libs/libmpcdec
	media-libs/libao
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${PN}-*.diff
	tc-export CC
}

src_install() {
	dobin mpc123
	dodoc AUTHORS README TODO
}
