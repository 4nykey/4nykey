# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools subversion

DESCRIPTION="Musepack audio compression tools"
HOMEPAGE="http://www.musepack.net"
ESVN_REPO_URI="http://svn.musepack.net/libmpc/trunk"
ESVN_PATCHES="${P}-as_needed.patch"
ESVN_BOOTSTRAP="eautoreconf"

SLOT="8"
LICENSE="LGPL-2.1"
KEYWORDS=""
IUSE="verbose-build cuetools"

DEPEND="
	media-libs/libreplaygain
"
RDEPEND="
	!media-libs/libmpcdec
	${DEPEND}
"

src_unpack() {
	subversion_fetch
	if use cuetools; then
		ESVN_PROJECT="cuetools" subversion_fetch \
		http://svn.berlios.de/svnroot/repos/cuetools/trunk \
		cuetools
		cd ${S}
		epatch "${FILESDIR}"/${P}-cuetools.diff
	else
		sed -i Makefile.am -e 's:mpcchap::'
	fi
	subversion_bootstrap
}

src_install() {
	einstall || die
}
