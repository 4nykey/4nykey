# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="An application for creating personalised icon themes"
HOMEPAGE="http://mejogid.ohallwebservices.com/site/index.php?q=node/1"
SRC_URI="
	http://mejogid.ohallwebservices.com/packages/${PV}/${P}.tar.gz
	examples? (
		http://mejogid.ohallwebservices.com/site/files/configurations.tar.gz
	)
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND=""
RDEPEND="
	>=dev-lang/python-2.4
	dev-python/dbus-python
	>=dev-python/pygtk-2.9
	dev-python/pyxdg
	gnome-base/librsvg
	media-gfx/imagemagick
"

PYTHON_MODNAME="TGenerator"

src_install() {
	distutils_src_install
	if use examples; then
		dodoc ${WORKDIR}/configurations/*.tgc
		elog "Sample configuration files were installed to"
		elog "/usr/share/doc/${PF}"
	fi
}
