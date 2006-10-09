# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

MY_P="${P/-applet/}"
DESCRIPTION="Computer Temperature Monitor is an applet for the GNOME panel"
HOMEPAGE="http://computertemp.berlios.de"
SRC_URI="http://download.berlios.de/computertemp/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="=dev-python/pygtk-2*
	=gnome-base/gnome-panel-2*"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"
