# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GTK frontend for X Neural Switcher"
HOMEPAGE="http://xneur.ru"
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-2
	=x11-misc/xneur-${PV}*
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS} -std=gnu99" || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS
}
