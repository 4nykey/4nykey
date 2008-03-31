# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git autotools

DESCRIPTION="Midori is a lightweight web browser"
HOMEPAGE="http://software.twotoasts.de/?page=midori"
EGIT_REPO_URI="http://software.twotoasts.de/media/midori.git"
EGIT_BOOTSTRAP="intltoolize --automake --copy && eautoreconf"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	net-libs/webkit
	x11-libs/libsexy
"
RDEPEND="
	${DEPEND}
"

src_install() {
	einstall || die
}
