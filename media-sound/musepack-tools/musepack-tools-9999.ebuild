# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/trunk"
ESVN_PATCHES="${P}-*.patch"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE="verbose-build"

RDEPEND="
	media-libs/libreplaygain
	media-libs/libcuefile
"
DEPEND="
	${RDEPEND}
	!media-libs/libmpcdec
"

pkg_setup() {
	use verbose-build && CMAKE_VERBOSE=y
}

src_configure() {
	local mycmakeargs="-DSHARED=ON"
	cmake-utils_src_configure
}
