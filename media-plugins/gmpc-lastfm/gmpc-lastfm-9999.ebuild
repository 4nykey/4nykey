# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Last.fm cover art plugin for gmpc"
HOMEPAGE="http://cms.qballcow.nl/index.php?page=Plugins"
ESVN_REPO_URI="https://svn.qballcow.nl/gmpc-last.fm/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=media-sound/gmpc-0.13.0
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf
}

src_install() {
	einstall || die "make install failed"
}
