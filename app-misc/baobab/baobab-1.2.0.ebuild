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

RDEPEND=">=x11-libs/gtk+-2.4"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README"

