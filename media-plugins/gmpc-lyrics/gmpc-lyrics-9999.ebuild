# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Lyrics plugin for gmpc"
HOMEPAGE="http://cms.qballcow.nl/index.php?page=Plugins"
ESVN_REPO_URI="https://ssl.bulix.org/svn/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=media-sound/gmpc-0.12.1
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
