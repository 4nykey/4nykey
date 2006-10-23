# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion toolchain-funcs

DESCRIPTION="Aften is an open-source A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/aften"
ESVN_PATCHES="${FILESDIR}/${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND="dev-util/cmake"
RDEPEND=""

src_compile() {
	mkdir -p build
	cd build
	cmake \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_C_COMPILER=$(which $(tc-getCC)) \
		 -DCMAKE_C_FLAGS_RELEASE="" \
		 .. || die
	emake || die
}

src_install() {
	make -C build DESTDIR="${D}" install || die
	dodoc Changelog README
}
