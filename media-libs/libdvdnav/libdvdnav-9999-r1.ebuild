# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://sourceforge.net/projects/dvd/"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/${PN}"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	>=media-libs/libdvdread-mplayer-9999
"
RDEPEND="
	${DEPEND}
"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
