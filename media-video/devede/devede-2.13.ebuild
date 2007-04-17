# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="DeVeDe is a program to create video DVDs, suitable for home players"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI="http://www.rastersoft.com/descargas/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	dev-python/pygtk
	media-video/mplayer
	media-video/dvdauthor
	app-cdr/cdrtools
"

PYTHON_MODNAME="DeVeDe"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv devede.py devede
	mkdir -p DeVeDe
	mv devede_*.py DeVeDe
	touch DeVeDe/__init__.py
	sed -i \
		-e "s:\(devede_.* import .*\):DeVeDe.\1:" \
		-e "s:import \(devede_.*\):from DeVeDe import \1:" devede
	sed "s:@PV@:${PV}:; s:@PF@:${PF}:" "${FILESDIR}"/setup.py > setup.py
}
