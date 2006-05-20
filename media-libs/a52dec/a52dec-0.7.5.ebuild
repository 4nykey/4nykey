# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/a52dec/a52dec-0.7.4-r1.ebuild,v 1.5 2004/07/29 02:55:52 tgall Exp $

inherit flag-o-matic cvs autotools

DESCRIPTION="library for decoding ATSC A/52 streams used in DVD"
HOMEPAGE="http://liba52.sourceforge.net/"
ECVS_SERVER="liba52.cvs.sourceforge.net:/cvsroot/liba52"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss static djbfft"

DEPEND="djbfft? ( sci-libs/djbfft )"
RDEPEND="${DEPEND} virtual/libc"

src_compile() {
	cvs_src_unpack
	cd ${S}

	append-flags -fPIC
	filter-flags -fprefetch-loop-arrays

	sed -i 's:AC_CONFIG_HEADERS:AM_CONFIG_HEADER:' configure.in
	use djbfft && sed -i 's:-lm:-lm -ldjbfft:' liba52/Makefile.am

	eautoreconf || die
}

src_compile() {
	econf \
		$(use_enable djbfft) \
		$(use_enable oss) \
		$(use_enable static) || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF}/html || die
	dodoc AUTHORS ChangeLog HISTORY NEWS README TODO doc/liba52.txt
}
