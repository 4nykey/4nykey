# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils toolchain-funcs

DESCRIPTION="C++ library implementing a real-time convolution matrix"
HOMEPAGE="https://kokkinizita.linuxaudio.org/linuxaudio"
SRC_URI="${HOMEPAGE}/downloads/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed \
		-e 's:-O[0-9]::' \
		-e '/march=native/d' \
		-e '/ldconfig/d' \
		-e 's:\(\tln -sf \$(ZITA-CONVOLVER_MIN).*\$(ZITA-CONVOLVER_\)SO):&\n\1MAJ):' \
		-i source/Makefile
}

src_compile() {
	emake CXX="$(tc-getCXX)" -C source
}

src_install() {
	local _p="${EPREFIX}/usr"
	local myemakeargs=(
		DESTDIR="${D}"
		PREFIX="${_p}"
		INCDIR="${_p}/include/${PN}"
		LIBDIR="${_p}/$(get_libdir)"
	)
	emake -C source "${myemakeargs[@]}" install
	printf '
prefix=%s
exec_prefix=${prefix}
libdir=${prefix}/%s
includedir=${prefix}/include
Name: %s
Description: %s
Version: %s
Libs: -L${libdir} -l%s
Cflags: -I${includedir}/%s\n
' "${_p}" $(get_libdir) ${PN} "${DESCRIPTION}" ${PV} ${PN} ${PN} > ${PN}.pc
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	einstalldocs
}
