# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a VC-1 library"
HOMEPAGE="http://nanocrew.net"
SRC_URI="${P}.tar.gz VC1_reference_decoder_release6.zip"
RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="virtual/libc"

pkg_nofetch() {
	einfo "Please download '${P}.tar.gz' from"
	einfo " http://nanocrew.net/software/${P}.tar.gz"
	einfo "and 'VC1_reference_decoder_release6.zip' from"
	einfo " http://www.smpte-vc1.org/TestMaterials.html"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack ${A}
	mv VC1_reference_decoder_release6/{decoder,shared}/*.[ch] \
		libvc1-1.0/src
	cd ${S}
	epatch ${FILESDIR}/inst_includes.diff
	sed -i /set/d bootstrap
	./bootstrap
}

src_install() {
	einstall || die
}
