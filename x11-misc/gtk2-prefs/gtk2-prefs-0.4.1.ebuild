# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/-/_}"
DESCRIPTION="gtk2_prefs is a GTK2 theme selector and font switcher"
HOMEPAGE="http://members.lycos.co.uk/alexv6"
SRC_URI="http://members.lycos.co.uk/alexv6/pub/gtk/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4.0"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	cd ${S}
	WANT_AUTOMAKE=1.7 autoreconf -fi
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README
}

