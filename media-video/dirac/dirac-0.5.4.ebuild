# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Dirac is a general-purpose wavelet video codec"
HOMEPAGE="http://www.bbc.co.uk/rd/projects/dirac/overview.shtml"
SRC_URI="mirror://sourceforge/dirac/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug mmx static pic doc"

DEPEND="doc? ( app-doc/doxygen
	app-text/dvipdfm
	app-text/tetex )"

src_compile() {
	sed -i 's:\<util\> ::' Makefile.in

	use doc || export ac_cv_prog_HAVE_DOXYGEN="no" ac_cv_prog_HAVE_LATEX="no"

	econf \
		`use_enable debug` \
		`use_enable mmx` \
		`use_enable static` \
		`use_with pic` || die

	emake || die
}

src_install() {
	einstall || die
	rm -rf ${D}/usr/share/doc/*
	if use doc; then
		einstall GENERIC_LIBRARY_NAME="${PF}/html/" -C doc
		rm -rf ${D}/usr/share/doc/${PF}/html/*.txt
	fi
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
}
