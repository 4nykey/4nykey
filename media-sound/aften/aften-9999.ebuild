# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Aften is an open-source A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
ESVN_REPO_URI="https://aften.svn.sourceforge.net/svnroot/aften"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug nocxx"

DEPEND="
	>=dev-util/cmake-2.4
"
RDEPEND=""

src_compile() {
	use nocxx || local myconf="-DBINDINGS_CXX=1"
	mkdir -p build
	cd build
	cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_C_FLAGS_RELEASE="" \
		-DSHARED=y \
		-DSVN_VERSION=${ESVN_WC_REVISION} \
		${myconf} \
		|| die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	make -C build DESTDIR="${D}" install || die "install failed"
	dodoc Changelog README
}
