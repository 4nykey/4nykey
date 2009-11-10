# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Sopcast is a Streaming Direct Broadcasting System based on P2P"
HOMEPAGE="http://www.sopcast.cn"
SRC_URI="http://download.sopcast.cn/download/sp-auth.tgz"
S="${WORKDIR}/sp-auth"
RESTRICT="strip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	amd64? ( app-emulation/emul-linux-x86-compat )
	x86? ( sys-libs/libstdc++-v3 )
"

src_install() {
	newbin sp-sc-auth sp-sc
	dodoc Readme
}
