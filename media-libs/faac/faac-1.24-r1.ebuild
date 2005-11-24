# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit eutils cvs

IUSE=""

S=${WORKDIR}/${PN}
DESCRIPTION="Free MPEG-4 audio codecs by AudioCoding.com"
HOMEPAGE="http://faac.sourceforge.net/"
ECVS_SERVER="cvs.audiocoding.com:/cvsroot/faac"
ECVS_MODULE="faac"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"

RDEPEND=">=media-libs/libsndfile-1.0.0"

DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.5
	sys-devel/autoconf
	>=sys-devel/automake-1.6"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/config.patch
	has_version '>=media-video/mpeg4ip-1.1.7' && \
		epatch ${FILESDIR}/mp4createx.diff
	WANT_AUTOMAKE=1.6 ./bootstrap || die
}
	
src_compile() {
	econf --with-mp4v2 || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README TODO docs/libfaac.pdf
}
