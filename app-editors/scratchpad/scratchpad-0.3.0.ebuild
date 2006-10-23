# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Scratchpad is a spatial text editor for the GNOME desktop"
HOMEPAGE="http://dborg.wordpress.com/scratchpad"
SRC_URI="http://www.chorse.org/stuff/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc dbus"

RDEPEND="
	>=x11-libs/gtksourceview-1.8.0
	>=gnome-base/gconf-2
	dbus? (
		|| (
			dev-libs/dbus-glib
			<sys-apps/dbus-0.90
		)
	)
"
DEPEND="
	${RDEPEND}
"

DOCS="AUTHORS ChangeLog NEWS README"
