# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/smplayer-skins/smplayer-skins-14.9.0.ebuild,v 1.2 2014/09/24 08:30:44 yngwin Exp $

EAPI=5

inherit subversion

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="http://smplayer.sourceforge.net/"
ESVN_REPO_URI="https://subversion.assembla.com/svn/${PN%-*}/${PN}/trunk/"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="
	dev-qt/qtcore:4
"
RDEPEND="
	media-video/smplayer
"

src_install() {
	einstall DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	dodoc Changelog README.txt
}
