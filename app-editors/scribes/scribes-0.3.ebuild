# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils gnome2

DESCRIPTION="Text Editor for GNOME"
HOMEPAGE="http://scribes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=dev-lang/python-2.4
	>=dev-python/pygtk-2.8.0
	>=dev-python/gnome-python-2.12.0
	>=dev-python/gnome-python-extras-2.12.0
	>=gnome-extra/yelp-2.12.0
"
DEPEND="
	${RDEPEND}
	>=gnome-base/gconf-2.12.0
"

DOCS="README AUTHORS COPYING TODO TRANSLATORS"
PYTHON_MODNAME="SCRIBES"

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_pkg_postrm
}
