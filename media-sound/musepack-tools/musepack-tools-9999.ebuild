# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion cmake-utils

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
SRC_URI="cuetools? ( http://download.berlios.de/cuetools/cuetools-1.3.1.tar.gz )"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/trunk"
ESVN_PATCHES="${P}-*.patch"

SLOT="8"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"
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
	[[ -n ${A} ]] && unpack ${A}
	subversion_src_unpack
}

src_compile() {
	if use cuetools; then
		cd "${WORKDIR}"/cuetools-1.3.1
		econf || die
		emake -C src/lib libcuefile.a || die
	fi
	cmake-utils_src_compile
}
