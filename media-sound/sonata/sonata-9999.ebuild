# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

DESCRIPTION="An elegant GTK+ client for the Music Player Daemon"
HOMEPAGE="http://sonata.berlios.de"
ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/sonata/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome lyrics taglib"

DEPEND="
	>=dev-python/pygtk-2.6
	gnome? ( || ( dev-python/gnome-python-extras >=dev-python/pygtk-2.10 ) )
"
RDEPEND="
	${DEPEND}
	lyrics? ( dev-python/ZSI )
	taglib? ( dev-python/tagpy )
"

DOCS="TRANSLATORS"
PYTHON_MODNAME="."
