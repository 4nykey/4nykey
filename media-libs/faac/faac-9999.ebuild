# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION="Free MPEG-4 audio codecs"
HOMEPAGE="http://faac.sourceforge.net/"
ECVS_SERVER="faac.cvs.sourceforge.net:/cvsroot/faac"
ECVS_MODULE="faac"

S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="mp4"

RDEPEND=">=media-libs/libsndfile-1.0.0
	mp4? || ( media-video/mpeg4ip-cvs
		media-libs/libmp4v2 )"

DEPEND="${RDEPEND}
	!<media-libs/faad2-2.0-r3"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.24-*.patch
	eautoreconf || die
}
	
src_compile() {
	econf $(use_with mp4 mp4v2) || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
