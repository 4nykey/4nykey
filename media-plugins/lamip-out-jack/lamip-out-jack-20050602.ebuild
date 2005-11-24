# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Jack ao module for LAMIP"
HOMEPAGE="http://lamip.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/outputjack"

SRC_URI="http://fondriest.frederic.free.fr/realisations/lamip/files/src/testing/contrib/lamip-outputJACK_${PV}.tar.bz2"

IUSE=""

DEPEND="media-sound/lamip
	media-libs/bio2jack"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf || die "autotools failed"
}

src_install() {
	make DESTDIR=${D} libdir=/usr/$(get_libdir)/lamip install || die "install failed"
}
