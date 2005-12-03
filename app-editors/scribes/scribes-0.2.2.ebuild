# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 distutils

DESCRIPTION="Text Editor for GNOME"
HOMEPAGE="http://scribes.sourceforge.net/"
RESTRICT="primaryuri"
SRC_URI="http://openusability.org/download.php/72/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8.0
	>=dev-python/gnome-python-2.12.0
	>=dev-python/gnome-python-extras-2.12.0
	>=gnome-extra/yelp-2.12.0"
DEPEND="${RDEPEND}
	>=gnome-base/gconf-2.12.0"

DOCS="README AUTHORS COPYING TODO TRANSLATORS"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Remove gconf installation from setup.py
	sed -i \
		"/Get gconf's default source/,/Problem restarting down gconf/d" \
		setup.py
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_pkg_postrm
}
