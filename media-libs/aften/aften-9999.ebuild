# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion cmake-utils

DESCRIPTION="Aften is an open-source A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
ESVN_REPO_URI="https://aften.svn.sourceforge.net/svnroot/aften"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="nocxx verbose-build"

DEPEND=""
RDEPEND=""

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_compile() {
	local mycmakeargs="
		-DCMAKE_C_FLAGS_RELEASE= \
		-DSHARED=ON \
		-DSVN_VERSION=${ESVN_WC_REVISION}
	"
	use nocxx || mycmakeargs="${mycmakeargs} -DBINDINGS_CXX=1"

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc Changelog README
}
