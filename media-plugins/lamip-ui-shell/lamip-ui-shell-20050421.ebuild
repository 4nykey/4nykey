# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Shell UI module for LAMIP"
HOMEPAGE="http://lamip.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/controlSHELL"

SRC_URI="http://fondriest.frederic.free.fr/realisations/lamip/files/src/testing/contrib/lamip-controlSHELL_${PV}.tar.bz2"

IUSE="debug"

DEPEND="media-sound/lamip
		sys-libs/readline"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf || die "autotools failed"
}

src_compile() {
	econf \
		`use_enable debug` || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} libdir=/usr/$(get_libdir)/lamip install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
