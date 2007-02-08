# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion distutils

DESCRIPTION="An elegant GTK+ client for the Music Player Daemon"
HOMEPAGE="http://sonata.berlios.de"
ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/sonata/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome soap taglib"

DEPEND="
	>=dev-python/pygtk-2.6
	gnome? ( || ( dev-python/gnome-python-extras >=dev-python/pygtk-2.10 ) )
"
RDEPEND="
	${DEPEND}
	soap? ( dev-python/soappy )
	taglib? ( dev-python/tagpy )
"

DOCS="TRANSLATORS"
PYTHON_MODNAME="."
