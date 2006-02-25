# Copyright 1999-2004 Gentoo Foundation.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs flag-o-matic autotools

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="http://faac.sourceforge.net/"
ECVS_SERVER="cvs.audiocoding.com:/cvsroot/faac"
ECVS_MODULE="faad2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms static"

RDEPEND="xmms? ( >=media-sound/xmms-1.2.7
	media-libs/id3lib )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${ECVS_MODULE}"

DOCS="AUTHORS ChangeLog INSTALL NEWS README README.linux TODO"

src_unpack() {
	cvs_src_unpack

	cd ${S}
	epatch ${FILESDIR}/${P}-mp4ff.patch
	epatch ${FILESDIR}/${P}-gcc4.patch
	eautoreconf || die
}

src_compile() {
	filter-flags -mfpmath=sse #34392
	#append-flags -DDRM #48140

	econf --without-drm `use_with xmms` `use_enable static` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ${DOCS}
}
