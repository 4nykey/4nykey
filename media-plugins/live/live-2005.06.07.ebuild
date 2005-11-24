# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/live/live-2005.01.29.ebuild,v 1.7 2005/06/06 10:17:47 corsair Exp $

IUSE=""

inherit flag-o-matic eutils toolchain-funcs multilib

MY_P=${P/-/.}
DESCRIPTION="Source-code libraries for standards-based RTP/RTCP/RTSP multimedia streaming, suitable for embedded and/or low-cost streaming applications"
HOMEPAGE="http://www.live.com/"
SRC_URI="http://www.live.com/liveMedia/public/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"

DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}

	# -fPIC is needed on amd64 because some applications are using live
	# to make shared libraries, which wont work without -fPIC on that
	# arch. The build system used isn't advanced enough to easily
	# specify that the test programs dont need to be PIC themselves,
	# and makefiles are generated on the fly, so I'm adding it as a
	# global flag.
	# Travis Tilley <lv@gentoo.org> 09 Apr 2004
	use amd64 && append-flags -fPIC
	use ppc && append-flags -fPIC

	sed -i.orig -e "s:-O2:${CXXFLAGS} -Wno-deprecated:" config.linux
	epatch ${FILESDIR}/gcc-3.3.patch
	#quick fix, something better will follow.
	rm testProgs/qtParse
}

src_compile() {
	./genMakefiles linux
	# emake doesn't work
	make CPLUSPLUS_COMPILER="$(tc-getCXX)" \
	     C_COMPILER="$(tc-getCC)" \
	     LINK="$(tc-getCXX) -o" || die
}

src_install() {
	# no installer, go manual ...

	# find and install libraries, mplayer needs to find
	# each library in a subdirectory with same name as
	# the lib

	local lib
	for lib in $(find ${S} -type f -name \*.a)
	do
		local dir
		dir=$(basename $(dirname ${lib}))

		insinto "/usr/$(get_libdir)/live/${dir}"
		doins "${lib}"

		insinto "/usr/$(get_libdir)/live/${dir}/include"
		doins ${S}/${dir}/include/*h
	done

	# find and install test programs
	exeinto /usr/bin
	find ${S}/testProgs -type f -perm +111 -exec doexe {} \;

	dodoc ${S}/README
}
