# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit distutils

DESCRIPTION="Cataloging software for CDs and DVDs"
HOMEPAGE="http://gnomecatalog.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${P}/${P}-1.tar.gz"
SRC_URI="http://www.josesanch.com/debian/${PN}_${PV/_/-}-1.tar.gz"
S="${WORKDIR}/${PN}"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

RDEPEND="
	virtual/python
	>=dev-python/pygtk-2.3.96
	dev-python/pyvorbis
	>=dev-python/pysqlite-2
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

PYTHON_MODNAME="${PN} mmpython"

src_unpack() {
	unpack ${A}
	use nls || sed -i /LC_MESSAGES/d ${S}/setup.py
}

src_compile() {
	distutils_src_compile
	use nls && emake -C po
}
