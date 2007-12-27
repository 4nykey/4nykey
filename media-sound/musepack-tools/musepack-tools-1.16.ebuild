# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

MY_P="mppenc-${PV}"
MPPDEC="mppdec-1.95e"
DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
SRC_URI="
	http://files.musepack.net/source/${MY_P}.tar.bz2
	http://xmixahlx.dyndns.org/gnu-linux/files/audio/musepack/source/${MPPDEC}.zip
"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"
IUSE="esd encode oss"

RDEPEND="
	esd? ( media-sound/esound )
	!media-sound/mppenc
"
DEPEND="
	${RDEPEND}
	>=dev-util/cmake-2.4
	app-arch/unzip
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
"

src_unpack() {
	unpack ${A}
	cd ${S}

	mv ../${MPPDEC} mppdec
	cp "${FILESDIR}"/CMakeLists.txt mppdec/
	epatch "${FILESDIR}"/mpp{de,en}c-*.diff
	use encode || sed -i "/add_subdirectory(src)/d" CMakeLists.txt
}

src_compile() {
	filter-flags -fprefetch-loop-arrays -ffast-math
	filter-flags -mfpmath=sse -mfpmath=sse,387

	local myconf
	use esd && myconf="${myconf} -DUSE_ESD=y"
	use oss && myconf="${myconf} -DUSE_OSS=y"
	use x86 && myconf="${myconf} -DUSE_ASM=y"

	cmake \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		${myconf} . || die

	make cfg || die
	use verbose-build && myconf="VERBOSE=y" || myconf=
	emake ${myconf} || die
}

src_install() {
	dobin mppdec/{mppdec,replaygain}
	use encode && dobin src/mppenc
	dodoc Changelog
}
