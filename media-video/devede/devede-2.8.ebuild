# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${P//[-.]/}"
DESCRIPTION="DeVeDe is a program to create video DVDs, suitable for home players"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI="http://www.rastersoft.com/descargas/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

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
DEPEND="
	sys-devel/gettext
"

PYTHON_MODNAME="DeVeDe"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv devede.py devede
	mkdir -p DeVeDe
	mv devede_*.py DeVeDe
	touch DeVeDe/__init__.py
	epatch "${FILESDIR}"/${PN}-*.diff
	sed -i "s:@PV@:${PV}:; s:@PF@:${PF}:" setup.py
}
