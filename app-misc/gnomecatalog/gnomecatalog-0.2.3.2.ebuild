# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit distutils versionator

MY_P="${PN}_$(replace_version_separator 3 -)"
DESCRIPTION="Cataloging software for CDs and DVDs"
HOMEPAGE="http://gnomecatalog.sourceforge.net/"
SRC_URI="http://www.josesanch.com/debian/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

RDEPEND="
	dev-python/gnome-python
	>=dev-python/pysqlite-2
	!dev-python/mmpython
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

PYTHON_MODNAME="${PN} mmpython"
DOCS="AUTHORS todo"

src_unpack() {
	unpack ${A}
	use nls || sed -i /LC_MESSAGES/d ${S}/setup.py
}

src_compile() {
	distutils_src_compile
	use nls && emake -C po
}

src_install() {
	distutils_src_install
	dosym /usr/bin/${PN} /usr/bin/gcatalog
}
