# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A converter between many dictonary formats (babylon, dictd, stardict, xdxf)"
HOMEPAGE="http://ktranslator.sourceforge.net/"
SRC_URI="mirror://sourceforge/ktranslator/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	dev-libs/libxml2
"
RDEPEND="
	${DEPEND}
"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
