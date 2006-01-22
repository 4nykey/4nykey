# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="gxmms2 - A gtk2 frontend for xmms2"
HOMEPAGE="http://wejp.homelinux.org/wejp/xmms2"
#SRC_URI="http://wejp.homelinux.org/wejp/xmms2/gxmms2-0.5.1.tar.gz"
EGIT_REPO_URI="rsync://git.xmms.se/xmms2/gxmms2.git/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gkrellm"

DEPEND="${RDEPEND}"
RDEPEND=">=x11-libs/gtk+-2.6
	media-sound/xmms2
	gkrellm? ( =app-admin/gkrellm-2* )"

src_unpack() {
	git_src_unpack
	cd ${S}
	use gkrellm || sed -i 's,\(all:.*\)gkrellxmms2\(.*\),\1\2,' Makefile
	sed -i 's:/usr/local:/usr:g' Makefile
}

src_install() {
	dobin gxmms2
	dodoc CHANGELOG README
}
