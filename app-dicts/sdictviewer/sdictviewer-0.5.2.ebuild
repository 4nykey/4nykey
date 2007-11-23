# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="SDict Viewer is a viewer for sdict.com dictionaries"
HOMEPAGE="http://sdictviewer.sf.net"
SRC_URI="http://dl.sharesource.org/${PN}/${P}-src.zip"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	>=virtual/python-2.5
	>=dev-python/pygtk-2.6
"

DEST="/usr/lib/${PN}"

src_compile() {
	return 0
}

src_install() {
	python_version
	insinto "${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/"
	doins -r src/sdictviewer
	newbin src/sdictviewer.py sdictviewer
	doicon icons/sdictviewer.png
	make_desktop_entry ${PN} "SDict Viewer" ${PN}
}
