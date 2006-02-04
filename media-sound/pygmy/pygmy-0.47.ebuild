# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Pygmy stands for Python GTK+ MPD player"
HOMEPAGE="http://pygmy.berlios.de"
SRC_URI="http://pygmy.berlios.de/files/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="gnome"

DEPEND=">=dev-python/pygtk-2.4.0
	gnome-base/libglade
	dev-python/empy
	media-libs/py-libmpdclient
	gnome? ( dev-python/gnome-python-extras )"
RDEPEND="${DEPEND}
	media-sound/mpd"
