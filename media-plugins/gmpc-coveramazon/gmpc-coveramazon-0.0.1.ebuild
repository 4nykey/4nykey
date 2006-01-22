# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools
IUSE=""

DESCRIPTION="Amazon cover art provider for gmpc"
HOMEPAGE="http://etomite.qballcow.nl/qgmpc-0.12.html"
SRC_URI=""
ESVN_REPO_URI="https://svn.qballcow.nl/${PN}/trunk"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

RDEPEND=">=x11-libs/gtk+-2.4
	dev-libs/libxml2
	|| ( >=media-sound/gmpc-svn-0.12.1
		>=media-sound/gmpc-0.12.1 )"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf || die
}

src_install() {
	einstall || die "make install failed"
}

