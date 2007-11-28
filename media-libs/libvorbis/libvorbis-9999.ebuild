# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.1.2.ebuild,v 1.4 2006/04/05 18:59:00 flameeyes Exp $

inherit subversion autotools flag-o-matic toolchain-funcs

DESCRIPTION="the Ogg Vorbis sound file format library"
HOMEPAGE="http://xiph.org/vorbis"
AT_M4DIR="m4"
ESVN_REPO_URI="http://svn.xiph.org/trunk/vorbis"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="
	>=media-libs/libogg-1.0
"
DEPEND="
	${RDEPEND}
	doc? ( dev-libs/libxslt )
"

S="${WORKDIR}/${P/_*/}"

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

	econf \
		$(use_enable doc docs)\
		|| die
	emake || die
}

src_install() {
	einstall || die

	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README todo.txt
	if use doc; then
		docinto txt
		dodoc doc/*.txt
		dohtml -r doc
	fi
}
