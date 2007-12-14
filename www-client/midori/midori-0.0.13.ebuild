# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Midori is a lightweight web browser"
HOMEPAGE="http://software.twotoasts.de/?page=midori"
SRC_URI="http://software.twotoasts.de/media/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	>=net-libs/webkit-28300
	x11-libs/libsexy
"
RDEPEND="
	${DEPEND}
"

src_install() {
	einstall || die
}
