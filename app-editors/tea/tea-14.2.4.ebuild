# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit gnome2

DESCRIPTION="TEA is the powerful text editor for GNU/Linux and *BSD."
HOMEPAGE="http://tea-editor.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome doc spell"

RDEPEND="
	>=x11-libs/gtk+-2.4
	spell? ( app-text/aspell )
	gnome? (
		x11-libs/gtksourceview
		>=gnome-base/gnome-vfs-2
		>=gnome-base/gconf-2
	)
"
DEPEND="
	${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.30
"

DOCS="AUTHORS ChangeLog NEWS TODO README"

G2CONF="
	$(use_enable !gnome legacy)
"

src_unpack() {
	gnome2_src_unpack
	sed -i \
		-e 's:\(PACKAGE_DATA_DIR\)"/tea/\([^"]\):\1"/\2:' \
		-e "s:doc/\":doc/${PF}/html/\":" \
		src/tea_defs.h
}

src_install() {
	gnome2_src_install
#	rm -f ${D}/usr/share/tea/doc/[A-Z]*
	dodir /usr/share/doc/${PF}/html
	mv -f ${D}/usr/share/tea/doc/* ${D}/usr/share/doc/${PF}/html
	mv -f ${D}/usr/share/tea/pixmaps ${D}/usr/share
	rm -rf ${D}/usr/share/tea
	make_desktop_entry tea "TEA text editor" tea_icon_v2.png "Utility;TextEditor"
}

