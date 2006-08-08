# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="A command-line xmms2 client"
HOMEPAGE="http://git.xmms.se/?p=nyello.git;a=summary"
EGIT_REPO_URI="git://git.xmms.se/xmms2/nyello.git/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-sound/xmms2
	sys-libs/readline"
RDEPEND="${DEPEND}"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
