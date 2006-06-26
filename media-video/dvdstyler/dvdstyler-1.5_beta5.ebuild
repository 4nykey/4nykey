# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdstyler/dvdstyler-1.4.ebuild,v 1.4 2005/12/29 01:23:41 halcy0n Exp $

MY_P=DVDStyler-${PV/_beta/b}_1

DESCRIPTION="DVD filesystem Builder"
HOMEPAGE="http://dvdstyler.sourceforge.net"
SRC_URI="mirror://sourceforge/dvdstyler/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="gnome"

RDEPEND="app-cdr/dvd+rw-tools
	dev-libs/expat
	dev-libs/glib
	media-libs/tiff
	media-libs/libpng
	media-libs/jpeg
	media-libs/netpbm
	>=media-video/dvdauthor-0.6.10
	media-video/mpgtx
	>=media-video/mjpegtools-1.6.2
	sys-libs/zlib
	x11-libs/gtk+
	>=x11-libs/wxGTK-2.4.2
	virtual/cdrtools
	virtual/libc
	gnome? ( >=gnome-base/libgnomeui-2.0 )
	media-libs/wxsvg
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_install() {
	make DESTDIR=${D} install || die "failed to install"
	rm -rf ${D}usr/share/doc
	insinto /usr/share/applications
	doins install.win32/dvdstyler.desktop

	dodoc AUTHORS ChangeLog README TODO
}
