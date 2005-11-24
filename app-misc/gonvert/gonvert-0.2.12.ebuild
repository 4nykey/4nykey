# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="gonvert is a conversion utility that allows conversion between many units"
HOMEPAGE="http://unihedron.com/projects/gonvert/index.php"
SRC_URI="http://unihedron.com/projects/gonvert/downloads/${P}.tar.gz"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/python
	dev-python/pygtk
	gnome-base/libglade"

src_compile() {
	sed -i 's:/usr/local:/usr:' Makefile
}

src_install() {
	make DESTDIR=${D} install
	rm -rf ${D}usr/share/doc
	dodoc doc/*
}
