# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit gnome2

DESCRIPTION="TEA is the powerful text editor for GNU/Linux and *BSD."
HOMEPAGE="http://tea.linux.kiev.ua/"
SRC_URI="http://tea.linux.kiev.ua/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	x11-libs/gtksourceview
	gnome-base/gnome-vfs
	gnome-base/gconf
	app-text/aspell"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.30"

DOCS="AUTHORS ChangeLog NEWS TODO README"
