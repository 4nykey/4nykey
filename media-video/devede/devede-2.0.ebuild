# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="DeVeDe is a program to create video DVDs, suitable for home players"
HOMEPAGE="http://www.rastersoft.com/programas/devede.html"
SRC_URI="http://www.rastersoft.com/descargas/${P//[-.]/}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-python/pygtk
	|| ( media-video/mplayer-svn media-video/mplayer )
	media-video/dvdauthor
	app-cdr/cdrtools"

src_install() {
	exeinto /usr/bin
	doexe devede
	insinto /usr/share/${PN}
	doins devede.glade pixmaps/*.png
	insinto /usr/share/pixmaps
	doins devede.png
	insinto /usr/share/applications
	doins devede.desktop
	dohtml docs/devede.html docs/*.jpg
}
