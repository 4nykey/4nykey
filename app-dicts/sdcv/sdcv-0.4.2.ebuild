# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="sdcv - console version of StarDict program"
HOMEPAGE="http://sdcv.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="readline nls"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.1
	readline? ( sys-libs/readline )
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_with readline) \
		|| die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
