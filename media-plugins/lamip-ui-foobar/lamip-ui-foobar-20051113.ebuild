# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="GTK2 UI module for LAMIP"
HOMEPAGE="http://lamip.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/controlfoobar-${PV}"

SRC_URI="http://fondriest.frederic.free.fr/realisations/lamip/files/src/testing/contrib/lamip-controlFOOBAR_${PV}.tar.bz2"

IUSE="debug unicode"

DEPEND="media-sound/lamip
		>=x11-libs/gtk+-2.6.0"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf || die "autotools failed"
}

src_compile() {
	econf \
		`use_enable unicode` \
		`use_enable debug` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} libdir=/usr/$(get_libdir)/lamip install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
