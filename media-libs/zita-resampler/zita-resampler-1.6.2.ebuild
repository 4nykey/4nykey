# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs
DESCRIPTION="A C++ library for resampling audio signals"
HOMEPAGE="https://kokkinizita.linuxaudio.org/linuxaudio"
SRC_URI="${HOMEPAGE}/downloads/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libsndfile
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default
	sed \
		-e 's:-O[0-9]::' \
		-e '/march=native/d' \
		-i {apps,source}/Makefile
	sed \
		-e '/ldconfig/d' \
		-e 's:\$(CXX) -shared.*:&\
	ln -sf $(ZITA-RESAMPLER_MIN) $(ZITA-RESAMPLER_SO):' \
		-e 's:\(ln -sf \$(ZITA-RESAMPLER_MIN).*\$(ZITA-RESAMPLER_\)SO):&\
	\1MAJ):' \
		-i source/Makefile
	sed \
		-e 's:LDLIBS += .*:& -L../source:' \
		-e 's:CPPFLAGS += .*:& -I../source:' \
		-e 's:\(install -d \)\(\$([A-Z]\+DIR)\):\1$(DESTDIR)\2:' \
		-e '/(DESTDIR)/ s:\.1\.gz:.1:' \
		-i apps/Makefile
}

src_compile() {
	tc-export CXX
	emake -C source
	emake -C apps
}

src_install() {
	local _p="${EPREFIX}/usr"
	local myemakeargs=(
		DESTDIR="${D}"
		PREFIX="${_p}"
		LIBDIR="${_p}/$(get_libdir)"
	)
	emake -C source "${myemakeargs[@]}" install
	emake -C apps "${myemakeargs[@]}" install
	printf '
prefix=%s
exec_prefix=${prefix}
libdir=${prefix}/%s
includedir=${prefix}/include
Name: %s
Description: %s
Version: %s
Libs: -L${libdir} -l%s
Cflags: -I${includedir}\n
' "${_p}" $(get_libdir) ${PN} "${DESCRIPTION}" ${PV} ${PN} > ${PN}.pc
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc
	einstalldocs
}
