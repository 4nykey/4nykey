# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit cvs autotools qt4

DESCRIPTION="Dirac is a general-purpose wavelet video codec"
HOMEPAGE="http://www.bbc.co.uk/rd/projects/dirac/overview.shtml"
ECVS_SERVER="dirac.cvs.sourceforge.net:/cvsroot/dirac"
ECVS_MODULE="compress"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug mmx doc qt4"

RDEPEND="
	qt4? ( $(qt4_min_version 4.0) )
"
DEPEND="
	doc? (
		app-doc/doxygen
		virtual/tetex
	)
"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch "${FILESDIR}"/${P}-*.diff
	eautoreconf || die
}

src_compile() {
	if use !doc; then
		export ac_cv_prog_HAVE_DOXYGEN="false" ac_cv_prog_HAVE_LATEX="false"
	fi

	econf \
		$(use_enable debug) \
		$(use_enable mmx) \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		|| die

	emake || die

	if use qt4; then
		cd util/encoder_gui
		qmake -project || die
		qmake || die
		emake || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	DOCDIR=${D}usr/share/doc/${PF}
	if [[ -d ${DOCDIR} ]]; then
		find ${DOCDIR} -type d -name CVS | xargs --no-run-if-empty rm -r
		find ${DOCDIR} -type f | xargs --no-run-if-empty chmod 644
	fi
	use qt4 && newbin util/encoder_gui/encoder_gui dirac_encoder_gui
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
}
