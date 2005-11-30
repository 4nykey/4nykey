# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A graphical tool to analyse directory trees"
HOMEPAGE="http://www.marzocca.net/linux/baobab.html"
SRC_URI="http://www.marzocca.net/linux/downloads/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/gnome-vfs-2.6
	>=gnome-base/gconf-2.0
	>=gnome-base/libgtop-2.10
	>=gnome-base/libglade-2.5.1
	>=gnome-base/libgnomecanvas-2.10.2"
DEPEND="${RDEPEND}
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README"

