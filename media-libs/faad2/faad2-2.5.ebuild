# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/faad2/faad2-2.0-r13.ebuild,v 1.1 2006/06/17 16:26:47 flameeyes Exp $

inherit eutils flag-o-matic autotools

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="http://www.audiocoding.com/"
SRC_URI="mirror://sourceforge/faac/${PN}-${PV/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms mp4"

RDEPEND="
	xmms? ( >=media-sound/xmms-1.2.7 media-libs/id3lib )
	mp4? ( media-video/mpeg4ip )
"
DEPEND="
	${RDEPEND}
	app-text/dos2unix
"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	find ${S} -type f -print0 | xargs -0 dos2unix -q
#	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
	epatch ${FILESDIR}/${PN}-*.patch
	eautoreconf
}

src_compile() {
	# see #34392
	filter-flags -mfpmath=sse

	append-flags -fno-strict-aliasing

	# drm needed for nothing but doesn't hurt
	#  but breakes decoding of he-aac 5.1 streams
	econf \
		--without-drm \
		--without-bmp \
		$(use_with xmms) \
		$(use_with mp4 mpeg4ip) \
		|| die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS ChangeLog NEWS README README.linux TODO

	# unneeded include, <systems.h> breaks building of apps, but
	# it is necessary because includes <sys/types.h>,
	# which is needed by /usr/include/mp4.h... so we just
	# include <sys/types.h> instead.  See bug #55767
	dosed "s:\"mp4ff_int_types.h\":<stdint.h>:" /usr/include/mp4ff.h
}
