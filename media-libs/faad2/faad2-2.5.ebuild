# Copyright 1999-2004 Gentoo Foundation.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs flag-o-matic autotools

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="http://faac.sourceforge.net/"
ECVS_SERVER="faac.cvs.sourceforge.net:/cvsroot/faac"
ECVS_MODULE="faad2"

S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms mp4"

RDEPEND="xmms? ( >=media-sound/xmms-1.2.7
	mp4? || ( media-video/mpeg4ip-cvs
		media-video/mpeg4ip )
	media-libs/id3lib )"

DEPEND="${RDEPEND}"

src_unpack() {
	cvs_src_unpack

	cd ${S}
	epatch ${FILESDIR}/${PN}-*.patch
	eautoreconf || die
}

src_compile() {
	filter-flags -mfpmath=sse #34392
	# enabling drm brakes decoding of he-aac 5.1 streams
	#append-flags -DDRM #48140

	econf --without-drm \
		$(use_with xmms) \
		$(use_with mp4 mpeg4ip) || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README README.linux TODO
}
