# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Listen, a music management and playback for GNOME"
HOMEPAGE="http://listengnome.free.fr/"
SRC_URI="mirror://sourceforge/listengnome/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/pygtk-2.6.0
	>=dev-python/gst-python-0.8.2
	dev-python/pyvorbis
	dev-python/pymad
	sys-apps/dbus
	>=dev-python/pysqlite-2.0.3"

MAKEOPTS="-j1"

src_install() {
	make DESTDIR="${D}" PREFIX=/usr install || die
	dodoc changelog copy
}
