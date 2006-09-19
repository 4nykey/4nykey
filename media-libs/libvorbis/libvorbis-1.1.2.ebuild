# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.1.2.ebuild,v 1.4 2006/04/05 18:59:00 flameeyes Exp $

inherit libtool flag-o-matic eutils toolchain-funcs

AO_VER="r1"
DESCRIPTION="the Ogg Vorbis sound file format library"
HOMEPAGE="http://xiph.org/vorbis/ http://www.geocities.jp/aoyoume/aotuv"
SRC_URI="http://downloads.xiph.org/releases/vorbis/${P}.tar.gz
	aotuv? (
	http://www.geocities.jp/aoyoume/aotuv/source_code/aotuv${AO_VER}_patch-${P/-/}.tar.bz2
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="aotuv"

RDEPEND=">=media-libs/libogg-1.0"
DEPEND="${RDEPEND}
	sys-apps/sed"

S="${WORKDIR}/${P/_*/}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fix a gcc crash.  With the new atexit patch to gcc, it
	# seems it does not handle -mno-ieee-fp very well.
	sed -i -e "s:-mno-ieee-fp::g" configure

	use aotuv && epatch "${WORKDIR}"/aotuv${AO_VER}-${P/-/}.diff

	elibtoolize

	epunt_cxx #74493
}

src_compile() {
	# Cannot compile with sse2 support it would seem #36104
	use x86 && [[ $(gcc-major-version) == 3 ]] && append-flags -mno-sse2

	# take out -fomit-frame-pointer from CFLAGS if k6-2
	is-flag -march=k6-3 && filter-flags -fomit-frame-pointer
	is-flag -march=k6-2 && filter-flags -fomit-frame-pointer
	is-flag -march=k6 && filter-flags -fomit-frame-pointer

	# over optimization causes horrible audio artifacts #26463
	filter-flags -march=pentium?

	# gcc-3.4 and k6 with -ftracer causes code generation problems #49472
	if [[ "$(gcc-major-version)$(gcc-minor-version)" == "34" ]]; then
		is-flag -march=k6* && filter-flags -ftracer
		is-flag -mtune=k6* && filter-flags -ftracer

		replace-flags -Os -O2
	fi

	# gcc on hppa causes issues when assembling
	use hppa && replace-flags -march=2.0 -march=1.0

	cd ${S} && sed -i -e 's/examples//' Makefile.in
	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README todo.txt
	use aotuv && dodoc aoTuV*.txt
	docinto txt
	dodoc doc/*.txt
	dohtml -r doc
}
