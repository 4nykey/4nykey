# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.1.0.ebuild,v 1.9 2004/11/11 09:44:57 eradicator Exp $

inherit libtool flag-o-matic eutils toolchain-funcs

DESCRIPTION="the Ogg Vorbis sound file format library"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html http://www.geocities.jp/aoyoume/aotuv/"
SRC_URI="http://www.geocities.jp/aoyoume/aotuv/${PN}-aotuv_b4.tar.gz.tgz"
S="${WORKDIR}/aotuv-b4_${PV}_111merged"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="pic static"

RDEPEND=">=media-libs/libogg-1.0"
DEPEND="${RDEPEND}
	sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd ${S}
	chmod 755 configure
	elibtoolize
}

src_compile() {
	# Cannot compile with sse2 support it would seem #36104
	use x86 && [ $(gcc-major-version) -eq 3 ] && append-flags -mno-sse2
	[ "`gcc-version`" == "3.4" ] && replace-flags -Os -O2

	# take out -fomit-frame-pointer from CFLAGS if k6-2
	is-flag -march=k6-3 && filter-flags -fomit-frame-pointer
	is-flag -march=k6-2 && filter-flags -fomit-frame-pointer
	is-flag -march=k6 && filter-flags -fomit-frame-pointer

	# over optimization causes horrible audio artifacts #26463
	filter-flags -march=pentium?

	econf \
		`use_with pic` \
		`use_enable static` || die

	emake || die
}

src_install() {
	einstall || die
	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README *.txt
	dohtml -r doc/*
}
