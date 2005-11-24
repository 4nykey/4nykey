# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cvs

DESCRIPTION="Dirac is a general-purpose wavelet video codec"
HOMEPAGE="http://www.bbc.co.uk/rd/projects/dirac/overview.shtml"
#SRC_URI="mirror://sourceforge/dirac/${P}.tar.gz"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/dirac"
ECVS_MODULE="compress"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug mmx static pic doc qt"

RDEPEND="qt? ( >=x11-libs/qt-4.0.0 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
	app-text/dvipdfm
	app-text/tetex )"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	sed -i 's:g++\*):*g++*):g' configure.ac
	sed -i 's:SUBDIRS = .*:SUBDIRS = :' util/Makefile.am
	WANT_AUTOMAKE=1.7 ./bootstrap || die
}

src_compile() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN="no" ac_cv_prog_HAVE_LATEX="no"

	econf \
		`use_enable debug` \
		`use_enable mmx` \
		`use_enable static` \
		`use_enable !static shared` \
		`use_with pic` || die

	emake || die

	if use qt; then
		cd util/encoder_gui
		qmake -project
		qmake
		make || die
	fi
}

src_install() {
	einstall || die
	use qt && dobin util/encoder_gui/encoder_gui
	rm -rf ${D}/usr/share/doc/*
	if use doc; then
		einstall GENERIC_LIBRARY_NAME="${PF}/html/" -C doc
		rm -rf ${D}/usr/share/doc/${PF}/html/*.txt
	fi
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
}
