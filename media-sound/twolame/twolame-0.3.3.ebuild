# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

DESCRIPTION="TwoLAME is a fork of tooLAME - an optimized MPEG Audio Layer 2 encoder."
HOMEPAGE="http://sourceforge.net/projects/twolame/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/twolame"
ECVS_MODULE="${PN}"
S=${WORKDIR}/${PN}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="media-libs/libsndfile"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	mkdir -p build
	sed -i s:twolame_frontend:frontend: src/frontend/Makefile.am
	WANT_AUTOMAKE=1.6 autoreconf -fi
}

src_install() {
	einstall || die
	dodoc AUTHORS README TODO
}
