# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/xvid/xvid-1.0.1.ebuild,v 1.6 2004/07/29 03:34:28 tgall Exp $

inherit eutils cvs

MY_P=${PN}core-${PV}
DESCRIPTION="high performance/quality MPEG-4 video de-/encoding solution"
HOMEPAGE="http://www.xvid.org/"
ECVS_SERVER="cvs.xvid.org:/xvid"
ECVS_MODULE="xvidcore"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha hppa ~amd64 ~ia64 ppc64"
IUSE="doc"

DEPEND="virtual/libc
	x86? ( >=dev-lang/nasm-0.98.36 )"

S="${WORKDIR}/${ECVS_MODULE}/build/generic"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	#epatch ${FILESDIR}/1.0.1-DESTDIR.patch

	# Appliying 64bit patch unconditionally.
	# Simple patch that works arch independent.
	# Danny van Dyk <kugelfang@gentoo.org> 2004/06/22
	#epatch ${FILESDIR}/${PN}-1.0.1-64bit-clean.patch

	einfo "Running bootstrap.sh"
	sed -i 's:head -1:head -n1:' bootstrap.sh
	./bootstrap.sh > /dev/null || die

}

src_install() {
	make install DESTDIR=${D} || die

	cd ${S}/../../
	dodoc AUTHORS ChangeLog README TODO doc/*

	local mylib="$(basename $(ls ${D}/usr/lib/libxvidcore.so*))"
	dosym ${mylib} /usr/lib/libxvidcore.so
	dosym ${mylib} /usr/lib/${mylib/%.[0-9]}

	if useq doc ; then
		dodoc CodingStyle doc/README
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
