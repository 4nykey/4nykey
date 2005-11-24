# Copyright 1999-2004 Gentoo Foundation.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs eutils libtool flag-o-matic

DESCRIPTION="The fastest ISO AAC audio decoder available, correctly decodes all MPEG-4 and MPEG-2 MAIN, LOW, LTP, LD and ER object type AAC files"
HOMEPAGE="http://faac.sourceforge.net/"
ECVS_SERVER=cvs.audiocoding.com:/cvsroot/faac
ECVS_MODULE=faad2

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="xmms static"

RDEPEND="xmms? ( >=media-sound/xmms-1.2.7
	media-libs/id3lib )"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	>=sys-devel/automake-1.6"

S=${WORKDIR}/${PN}

DOCS="AUTHORS ChangeLog INSTALL NEWS README README.linux TODO"

src_unpack() {
	cvs_src_unpack

	cd ${S}
	#grep -lr --include=*.am libmp4ff.a * | xargs sed -i 's:libmp4ff\.a:libmp4ff.la:'
	#sed -i 's:noinst_LIBRARIES:lib_LTLIBRARIES:; s:_a_:_la_:' common/mp4ff/Makefile.am
	epatch ${FILESDIR}/${P}-mp4ff.patch
	epatch ${FILESDIR}/${P}-gcc4.patch
	einfo "Runnnig bootstrap"
	WANT_AUTOMAKE=1.6 /bin/sh bootstrap >& /dev/null || die
}

src_compile() {
	filter-flags -mfpmath=sse #34392
	#append-flags -DDRM #48140
	#epatch ${FILESDIR}/specrec.diff

	#econf --with-drm `use_with xmms` `use_enable static` || die
	econf --without-drm `use_with xmms` `use_enable static` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc ${DOCS}
}
