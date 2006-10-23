# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsoundtouch/libsoundtouch-1.3.0.ebuild,v 1.1 2005/05/19 02:47:17 kito Exp $

inherit eutils

IUSE="static"

S="${WORKDIR}/${P/lib/}"

DESCRIPTION="Audio processing library for changing tempo, pitch and playback rates."
HOMEPAGE="http://www.surina.net/soundtouch"
SRC_URI="http://www.surina.net/soundtouch/soundtouch-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd ${S}
	epatch "${FILESDIR}/${P}-sse.diff"
}

src_compile() {
	econf \
		$(use_enable static) \
		--enable-shared \
		--disable-integer-samples \
		--with-pic || die "./configure failed"
	# fixes C(XX)FLAGS from configure, so we can use *ours*
	emake CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" install || die
	rm -f ${D}/usr/share/doc/${PF}/COPYING.TXT  # remove obsolete LICENCE file
}
