# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="An automatic keyboard layout switcher"
SRC_URI="http://cidnet.crew.org.ru/frs/download.php/12/${P}.tar.bz2"
HOMEPAGE="http://xneur.cidnet.crew.org.ru"
DEPEND="virtual/x11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

src_install () {
	einstall || die
	dodoc AUTHORS README COPYING INSTALL NEWS ChangeLog
}
