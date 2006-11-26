# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P/dvd/DVD}"
DESCRIPTION=""
HOMEPAGE="http://gdvdshrink.sourceforge.net"
SRC_URI="mirror://sourceforge/gdvdshrink/${MY_P}.tgz"
S="${WORKDIR}/opt/lxDVDshrink"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="media-video/lsdvd
	media-video/vamps
	media-video/mplayer
	dev-perl/XML-XPath
	dev-perl/Data-DumpXML
"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${PN}-misc.diff
}

src_install() {
	local installvendorlib
	eval `perl '-V:installvendorlib'`

	exeinto /usr/bin
	doexe lxdvdshrink.pl
	insinto ${installvendorlib}/LxDVDShrink
	doins *.pm
	dodoc DOCS/{CHANGES,README,TODO}
}
