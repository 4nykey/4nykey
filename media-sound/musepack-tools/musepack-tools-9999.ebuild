# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion cmake-utils

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/trunk"
ESVN_PATCHES="${P}-*.patch"

SLOT="8"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"
IUSE="verbose-build"

RDEPEND="
	media-libs/libreplaygain
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}
