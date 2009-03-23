# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xvid/xvid-1.0.1.ebuild,v 1.6 2004/07/29 03:34:28 tgall Exp $

inherit autotools cvs

DESCRIPTION="high performance/quality MPEG-4 video de-/encoding solution"
HOMEPAGE="http://www.xvid.org/"
ECVS_SERVER="cvs.xvid.org:/xvid"
ECVS_MODULE="xvidcore"
S="${WORKDIR}/${ECVS_MODULE}/build/generic"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~x86 ~amd64"
IUSE="doc examples"

DEPEND="
	dev-lang/yasm
"

src_unpack() {
	cvs_src_unpack

	cd "${S}"/../..
	epatch "${FILESDIR}"/${PN}-*.patch

	cd ${S}
	eautoreconf
	# it doesn't use automake but needs few files from it to be installed
	automake --add-missing --copy > /dev/null 2>&1
}

src_compile() {
	econf || die
	emake || die
	use examples && emake -C ../../examples
}

src_install() {
	make install DESTDIR=${D} || die

	cd ../..
	use examples && dobin examples/xvid_{encraw,decraw,bench}
	dodoc AUTHORS ChangeLog README TODO doc/*

	if use doc; then
		dodoc CodingStyle doc/README
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
