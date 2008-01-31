# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="Widget to render html documents"
HOMEPAGE="http://tkhtml.tcl.tk"
ECVS_SERVER="tkhtml.tcl.tk:/tkhtml"
ECVS_MODULE="htmlwidget"
ECVS_PASS="anonymous"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="threads debug"

DEPEND="
	dev-lang/tk
"
RDEPEND="
	${DEPEND}
"

src_compile() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc ChangeLog README
}
