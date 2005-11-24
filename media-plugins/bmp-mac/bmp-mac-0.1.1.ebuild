# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

IUSE=""

DESCRIPTION="Monkey's Audio input plugin for BMP"
HOMEPAGE="http://sourceforge.net/projects/mac-port"
SRC_URI="mirror://sourceforge/mac-port/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="media-sound/beep-media-player
	media-sound/mac"

src_compile () {
	econf --disable-static || die
	sed -i "s:@BMP_INPUT_PLUGIN_DIR@:`beep-config --input-plugin-dir`:" \
		src/Makefile
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
