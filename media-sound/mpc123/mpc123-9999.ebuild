# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial

DESCRIPTION="mpc123 - Musepack Console audio player"
HOMEPAGE="http://mpc123.sf.net"
EHG_REPO_URI="http://mpc123.hg.sourceforge.net:8000/hgroot/mpc123"
S="${WORKDIR}/mpc123"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-sound/musepack-tools-444
	media-libs/libao
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	mercurial_src_unpack
	cd ${S}
	epatch "${FILESDIR}"/${PN}-*.diff
	tc-export CC
}

src_install() {
	dobin mpc123
	dodoc AUTHORS README TODO
}
