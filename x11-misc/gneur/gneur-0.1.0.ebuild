# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An automatic keyboard layout switcher"
SRC_URI="http://xneur.narod.ru/xneur/${P}.tar.gz"
HOMEPAGE="http://xneur.narod.ru"
RESTRICT="primaryuri"

RDEPEND="
	=x11-libs/gtk+-2*
	x11-libs/libXmu
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

src_unpack() {
	unpack ${A}
	sed -i "s:gtk+-2.0 gdk-2.0:gtk+-2.0 gthread-2.0 xmu:g" ${S}/configure
}

src_install () {
	einstall || die
	rm -rf ${D}/usr/doc/Gneur
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO .xneur/*
}
