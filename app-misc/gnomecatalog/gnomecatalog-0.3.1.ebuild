# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit distutils versionator

MY_P="${PN}_$(replace_version_separator 3 -)"
DESCRIPTION="Cataloging software for CDs and DVDs"
HOMEPAGE="https://launchpad.net/gnomecatalog"
SRC_URI="http://ppa.launchpad.net/josesanch/ubuntu/pool/main/g/${PN}/${MY_P}.orig.tar.gz"
S="${WORKDIR}/${PN}-$(get_version_component_range 2-)"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

RDEPEND="
	dev-python/pygtk
	gnome-base/libglade
	dev-python/gnome-python
	|| (
		>=dev-lang/python-2.5
		>=dev-python/pysqlite-2
	)
	dev-python/mmpython
"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

DOCS="AUTHORS todo"

pkg_setup() {
	python_version
	if ! has_version '>=dev-python/pysqlite-2' && \
	! built_with_use --missing false 'dev-lang/python' 'sqlite'; then
		eerror "Please, either remerge >=dev-lang/python-2.5 with USE=sqlite,"
		eerror "or emerge dev-python/pysqlite."
		die "no sqlite module"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	use nls || sed -i /LC_MESSAGES/d setup.py
	epatch "${FILESDIR}"/${PN}-pysqlite.diff
}

src_compile() {
	distutils_src_compile
	if use nls; then
		emake -C po || die "emake po failed"
	fi
}

src_install() {
	distutils_src_install
	dosym /usr/bin/${PN} /usr/bin/gcatalog
}
