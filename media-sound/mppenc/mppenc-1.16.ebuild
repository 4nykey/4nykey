# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mppenc/mppenc-1.16.ebuild,v 1.11 2007/11/23 21:26:20 corsair Exp $

EAPI="2"

inherit toolchain-funcs flag-o-matic cmake-utils

DESCRIPTION="musepack audio encoder"
HOMEPAGE="http://www.musepack.net/"
SRC_URI="http://files.musepack.net/source/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!<media-sound/musepack-tools-444"

src_unpack() {
	unpack ${A}

	# Respect user-chosen CFLAGS
	sed -i -e '/CMAKE_C_FLAGS/d' "${S}/CMakeLists.txt"
}
