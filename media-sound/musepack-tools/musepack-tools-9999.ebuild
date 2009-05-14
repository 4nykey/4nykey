# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils autotools subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/trunk"
ESVN_PATCHES="${P}-*.patch"

SLOT="8"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE="verbose-build cuetools"

RDEPEND="
	media-libs/libreplaygain
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_unpack() {
	subversion_src_unpack
	if use cuetools; then
		ESVN_PROJECT="cuetools" subversion_fetch \
		http://svn.berlios.de/svnroot/repos/cuetools/trunk \
		cuetools
		eautoreconf
	else
		sed -i CMakeLists.txt -e '/add_subdirectory(mpcchap)/d'
	fi
}

src_compile() {
	if use cuetools; then
		cd cuetools
		econf || die
		emake -C src/lib libcuefile.a || die
		local mycmakeargs="
			-DCUEFILE_INCLUDE_DIR=${S}/cuetools/src/lib
		"
	fi
	cmake-utils_src_compile
}
