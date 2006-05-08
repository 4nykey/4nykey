# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION="TwoLAME is an optimized MPEG Audio Layer 2 encoder (a fork of tooLAME)"
HOMEPAGE="http://sourceforge.net/projects/twolame/"
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
	sed -i 's: doc::' Makefile.am
	mkdir -p build
	eautoreconf || die
}

src_install() {
	einstall || die
	dodoc AUTHORS README TODO
}
