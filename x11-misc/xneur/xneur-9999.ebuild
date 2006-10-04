# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION="An automatic keyboard layout switcher"
HOMEPAGE="http://xneur.narod.ru"
ECVS_SERVER="${PN}.cvs.sourceforge.net:/cvsroot/${PN}"
ECVS_MODULE="${PN}-main"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk"

RDEPEND="
	gtk? ( =x11-libs/gtk+-2* )
	virtual/xft
	x11-libs/libXmu
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	echo "AC_CONFIG_SUBDIRS([gxneur])" >> configure.in
	eautoreconf
}

src_compile() {
	econf || die
	emake || die
	if use gtk; then
		cd gxneur
		econf || die
		emake || die
	fi
}

src_install () {
	einstall || die
	use gtk && einstall -C gxneur || die
	rm -rf ${D}/usr/doc
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO
}
