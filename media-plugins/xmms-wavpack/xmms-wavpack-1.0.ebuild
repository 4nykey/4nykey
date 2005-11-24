# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit subversion

IUSE=""

DESCRIPTION="Wavpack input plugin for XMMS"
HOMEPAGE="http://www.wavpack.com"
ESVN_REPO_URI="http://svn.caddr.com/svn/${PN}/trunk"
ESVN_BOOTSTRAP="WANT_AUTOMAKE=1.7 ./autogen.sh"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="media-sound/xmms
	>=media-sound/wavpack-4.2_beta3"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
