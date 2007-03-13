# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faad2/faad2-2.0-r13.ebuild,v 1.1 2006/06/17 16:26:47 flameeyes Exp $

inherit flag-o-matic autotools

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="http://www.audiocoding.com/"
SRC_URI="mirror://sourceforge/faac/${PN}-${PV/_/-}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${PN}-*.patch
	eautoreconf
}

src_compile() {
	filter-flags -mfpmath=sse # see #34392
	append-flags -fno-strict-aliasing

	# drm needed for nothing but doesn't hurt
	#  but breakes decoding of he-aac 5.1 streams
	econf \
		--without-drm \
		|| die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README README.linux TODO
}
