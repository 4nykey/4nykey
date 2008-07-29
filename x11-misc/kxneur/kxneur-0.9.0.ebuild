# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="X Neural Switcher front-end for KDE"
HOMEPAGE="http://xneur.ru"
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	kde-base/kdelibs
	=x11-misc/xneur-${PV}*
"
DEPEND="
	${RDEPEND}
	x11-libs/libxkbfile
"

src_unpack() {
	kde_src_unpack
	epatch "${FILESDIR}"/${P}*.diff
}
