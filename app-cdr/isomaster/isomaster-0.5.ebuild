# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An application for creating and modifying ISO9660 images"
HOMEPAGE="http://littlesvr.ca/isomaster"
SRC_URI="http://littlesvr.ca/isomaster/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-2.6
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:\<cc\>:$(CC) $(CFLAGS):' \
		-e 's:\([^)$]*\)\(\$(GTKLIBS)\)\(.*\): ${LDFLAGS}\3\1\2:' \
		Makefile bk/Makefile
	sed -i "/^CFLAGS/d" iniparser-2.15/Makefile
}

src_compile() {
	emake PREFIX=/usr || die
}

src_install() {
	make PREFIX=/usr DESTDIR="${D}" install || die
	dodoc {CHANGELOG,CREDITS,README}.TXT
}
