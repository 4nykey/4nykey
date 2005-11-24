# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Plugins for Gnome keyboard layout switcher"
HOMEPAGE="http://gswitchit.sourceforge.net"
MY_P=${P/-/_}
SRC_URI="mirror://sourceforge/gswitchit/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0
	>=gnome-base/libglade-2.0
	>=gnome-base/gconf-2.0
	>=gnome-base/libgnomeui-2.0
	>=gnome-base/gnome-applets-2.6.1
	>=net-libs/libsoup-2.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

USE_DESTDIR="1"
DOCS="AUTHORS NEWS README"
