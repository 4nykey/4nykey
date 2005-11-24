# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Monkey's Audio input plugin for XMMS"
HOMEPAGE="http://sourceforge.net/projects/mac-port"
SRC_URI="mirror://sourceforge/mac-port/${P}.tar.gz"

IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="media-sound/mac
	media-sound/xmms"
DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS ChangeLog COPYING INSTALL NEWS README TODO
}
