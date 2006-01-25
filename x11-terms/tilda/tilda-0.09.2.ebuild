# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A drop down terminal, similar to the consoles found in first person shooters"
HOMEPAGE="http://tilda.sourceforge.net"
SRC_URI="mirror://sourceforge/tilda/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="x11-libs/vte
	dev-libs/confuse"

src_install() {
	einstall || die
}
