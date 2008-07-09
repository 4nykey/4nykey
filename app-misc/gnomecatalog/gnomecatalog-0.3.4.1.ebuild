# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit distutils

DESCRIPTION="Cataloging software for CDs and DVDs"
HOMEPAGE="http://www.gnomecatalog.org"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"
S="${WORKDIR}/${P}.orig"

KEYWORDS="~x86 ~amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

RDEPEND="
	>=dev-lang/python-2.5
	dev-python/pygtk
	gnome-base/libglade
	dev-python/gnome-python
	>=dev-python/pysqlite-2
	dev-python/kaa-metadata
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

DOCS="AUTHORS ChangeLog README TODO"
