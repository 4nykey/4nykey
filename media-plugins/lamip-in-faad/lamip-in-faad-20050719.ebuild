# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="AAC input plugin for LAMIP"
HOMEPAGE="http://lamip.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/inputmp4"

SRC_URI="http://fondriest.frederic.free.fr/realisations/lamip/files/src/0.0.3/lamip-inputMP4_${PV}.tar.bz2"

IUSE="aac mp4"

DEPEND="media-sound/lamip
	aac? ( >=media-libs/faad2-2.1 )
	mp4? || ( media-video/mpeg4ip-cvs 
		media-video/mpeg4ip )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	eautoreconf || die "autotools failed"
}

src_install() {
	make DESTDIR=${D} libdir=/usr/$(get_libdir)/lamip install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
