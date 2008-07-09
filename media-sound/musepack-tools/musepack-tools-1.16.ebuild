# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic cmake-utils

MY_P="mppenc-${PV}"
MPPDEC="mppdec-1.95e"
DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
SRC_URI="
	http://files.musepack.net/source/${MY_P}.tar.bz2
	http://4nykey.googlecode.com/files/${MPPDEC}.zip
"
S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE="esd encode oss verbose-build"

RDEPEND="
	esd? ( media-sound/esound )
	!media-sound/mppenc
"
DEPEND="
	${RDEPEND}
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
	sed -i CMakeLists.txt -e '/CMAKE_C_FLAGS/d'
	use encode || sed -i CMakeLists.txt -e "/add_subdirectory(src)/d"
}

src_compile() {
	filter-flags -fprefetch-loop-arrays -ffast-math
	filter-flags -mfpmath=sse -mfpmath=sse,387

	use verbose-build && CMAKE_COMPILER_VERBOSE=y

	local mycmakeargs="
		$(cmake-utils_use_enable esd ESD) \
		$(cmake-utils_use_enable oss OSS) \
		$(cmake-utils_use_enable x86 ASM)
	"
	cmake-utils_src_configurein
	cmake-utils_src_make cfg
	cmake-utils_src_make
}

src_install() {
	dobin mppdec/{mppdec,replaygain}
	use encode && dobin src/mppenc
	dodoc Changelog
}
