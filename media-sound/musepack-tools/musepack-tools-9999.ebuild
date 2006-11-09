# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic subversion toolchain-funcs

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/mppenc/trunk"
#ESVN_PATCHES="${FILESDIR}/${PN}-*.diff"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="-*"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	>=dev-util/cmake-2.4
"

src_unpack() {
	subversion_src_unpack
	sed -i "/CMAKE_C_FLAGS/d" ${S}/CMakeLists.txt
}

src_compile() {
	filter-flags -fprefetch-loop-arrays
	filter-flags -mfpmath=sse -mfpmath=sse,387
	append-flags -fno-strict-aliasing -fno-gcse -fno-finite-math-only
	append-flags -fno-unsafe-math-optimizations

	cmake \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_C_COMPILER=$(which $(tc-getCC)) \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		. || die
	emake || die
}

src_install() {
	dobin src/mppenc
	dodoc Changelog
}
