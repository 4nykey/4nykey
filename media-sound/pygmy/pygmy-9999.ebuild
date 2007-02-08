# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion distutils

DESCRIPTION="Pygmy stands for PYthon Gtk+ Mpd plaYer"
HOMEPAGE="http://pygmy.berlios.de"
ESVN_REPO_URI="svn://svn.berlios.de/pygmy/trunk"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE="gnome"

DEPEND="
	>=dev-python/pygtk-2.4.0
	gnome-base/libglade
	dev-python/empy
	media-libs/py-libmpdclient
	gnome? ( dev-python/gnome-python-extras )
"
RDEPEND="
	${DEPEND}
	media-sound/mpd
"

PYTHON_MODNAME="."
