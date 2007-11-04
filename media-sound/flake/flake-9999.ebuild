# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Flake is an open-source FLAC audio encoder"
HOMEPAGE="http://flake-enc.sf.net"
ESVN_REPO_URI="https://flake-enc.svn.sourceforge.net/svnroot/flake-enc"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND="
	>=dev-util/cmake-2.4
"
RDEPEND=""

src_compile() {
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	mkdir -p build
	cd build
	cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_C_FLAGS_RELEASE="" \
		-DSHARED=y \
		-DSVN_VERSION=${ESVN_WC_REVISION} \
		|| die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	make -C build DESTDIR="${D}" install || die "install failed"
	dodoc Changelog README
}
