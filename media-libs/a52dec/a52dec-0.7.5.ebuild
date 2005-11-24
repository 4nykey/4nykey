# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/a52dec/a52dec-0.7.4-r1.ebuild,v 1.5 2004/07/29 02:55:52 tgall Exp $

inherit flag-o-matic cvs

DESCRIPTION="library for decoding ATSC A/52 streams used in DVD"
HOMEPAGE="http://liba52.sourceforge.net/"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/liba52"
ECVS_MODULE="${PN}"
S=${WORKDIR}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss static djbfft"

DEPEND=">=sys-devel/autoconf-2.52d-r1
	x86? ( djbfft? ( sci-libs/djbfft ) )
	amd64? ( djbfft? ( sci-libs/djbfft ) )"
RDEPEND="virtual/libc"

src_compile() {
	append-flags -fPIC
	filter-flags -fprefetch-loop-arrays

	sed -i 's:AC_CONFIG_HEADERS:AM_CONFIG_HEADER:' configure.in
	if (use x86 || use amd64) && use djbfft; then
		sed -i 's:-lm:-lm -ldjbfft:' liba52/Makefile.am
		local myconf="$(use_enable djbfft)"
	fi

	WANT_AUTOMAKE=1.6 ./bootstrap

	(use x86 || use amd64) && local myconf="$(use_enable djbfft)"

	econf ${myconf} $(use_enable oss) \
		$(use_enable static) $(use_enable !static shared) ||
		die "configure failed"

	emake || die "emake failed"
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF}/html || die
	dodoc AUTHORS ChangeLog HISTORY NEWS README TODO doc/liba52.txt
}
