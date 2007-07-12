# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

PLP="polipo-1.0.1"
DESCRIPTION="Html Viewer 3 - the minimalist browser designed to test Tkhtml3"
HOMEPAGE="http://tkhtml.tcl.tk/hv3.html"
SRC_URI="http://www.pps.jussieu.fr/~jch/software/files/polipo/${PLP}.tar.gz"
ECVS_SERVER="tkhtml.tcl.tk:/tkhtml"
ECVS_MODULE="htmlwidget/hv"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="sqlite3"

DEPEND=""
RDEPEND="
	dev-tcltk/tkhtml
	dev-tcltk/tkimg
	sqlite3? ( dev-db/sqlite:3 )
"

src_unpack() {
	cvs_src_unpack
	unpack ${A}
	cd ${PLP}
	epatch ${FILESDIR}/hv3_polipo.patch
}

src_compile() {
	cd ${WORKDIR}/${PLP}
	emake CDEBUGFLAGS="${CFLAGS}" polipo || die
}

src_install() {
	dobin ${FILESDIR}/hv3
	insinto /usr/share/hv3
	doins *.tcl index.html
	newbin ${WORKDIR}/${PLP}/polipo hv3_polipo
#	diropts -m1777
#	keepdir /var/cache/polipo
}
