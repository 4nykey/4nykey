# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Default UI module for LAMIP"
HOMEPAGE="http://lamip.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/controldefault"

SRC_URI="http://fondriest.frederic.free.fr/realisations/lamip/files/src/0.0.3/lamip-controlDEFAULT_${PV}.tar.bz2"

IUSE="debug network"

DEPEND="media-sound/lamip
		>=x11-libs/gtk+-2.6.0
		network? ( net-misc/curl )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf || die "autotools failed"
}

src_compile() {
	econf \
		`use_enable network shoutcast` \
		`use_enable debug` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} libdir=/usr/$(get_libdir)/lamip install || die "install failed"
}
