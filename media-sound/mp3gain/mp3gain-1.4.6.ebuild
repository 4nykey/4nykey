# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3gain/mp3gain-1.4.6.ebuild,v 1.1 2005/02/03 10:14:16 eradicator Exp $

inherit cvs eutils

IUSE=""

MY_P=${P//./_}

DESCRIPTION="MP3Gain automatically adjusts mp3s so that they all have the same volume"
HOMEPAGE="http://mp3gain.sourceforge.net"
#SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"
ECVS_SERVER="mp3gain.cvs.sourceforge.net:/cvsroot/mp3gain"
ECVS_MODULE="mp3gain"
S=${WORKDIR}/${ECVS_MODULE}

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/makefile.diff
}

src_install () {
	dobin mp3gain
}
