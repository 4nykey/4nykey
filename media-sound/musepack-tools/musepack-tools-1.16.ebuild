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
"
DEPEND="
	${RDEPEND}
	>=dev-util/cmake-2.4
	app-arch/unzip
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
	amd64? ( dev-lang/nasm )
"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i "/CMAKE_C_FLAGS/d" CMakeLists.txt
	use encode || sed -i "/add_subdirectory/d" CMakeLists.txt

	mv ../${MPPDEC} mppdec
	epatch "${FILESDIR}"/mppdec-*.diff
	echo "add_subdirectory(mppdec)" >> CMakeLists.txt
	cp "${FILESDIR}"/CMakeLists.txt mppdec/
	sed -i \
		'/USE_IRIX_AUDIO/d; /USE_ESD_AUDIO/d; /USE_OSS_AUDIO/d; /USE_ASM/d' \
		mppdec/mpp.h
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
		-DCMAKE_C_COMPILER=$(which $(tc-getCC)) \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		${myconf} . || die

	make cfg || die
	emake || die
}

src_install() {
	dobin mppdec/{mppdec,replaygain}
	use encode && dobin src/mppenc
	dodoc Changelog
}
