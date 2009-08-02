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
	subversion_fetch
	if use cuetools; then
		ESVN_PROJECT="${PN}/libcuefile" subversion_fetch \
			http://svn.musepack.net/libcuefile/trunk libcuefile
		ESVN_PATCHES+=" ${P}-cue_cmake.diff"
	else
		sed -i "${S}"/CMakeLists.txt -e '/add_subdirectory(mpcchap)/d'
	fi
	subversion_bootstrap
}
