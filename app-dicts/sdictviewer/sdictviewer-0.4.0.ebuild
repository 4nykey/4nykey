# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

DESCRIPTION="SDict Viewer is a viewer for sdict.com dictionaries"
HOMEPAGE="http://sdictviewer.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
S="${WORKDIR}/${PN}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	>=virtual/python-2.4
	>=dev-python/pygtk-2.6
"

src_install() {
	insinto /opt/${PN}
	doins *.py
	cat << EOF > ${T}/sdictview
#!/bin/sh
/usr/bin/python /opt/${PN}/sdictview.py
EOF
	dobin ${T}/sdictview
}

pkg_postinst() {
	python_mod_optimize ${ROOT}opt/${PN}
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}opt/${PN}
}
