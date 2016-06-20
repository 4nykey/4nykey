# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://subversion.assembla.com/svn/${PN%-*}/${PN}/trunk/"
else
	SRC_URI="mirror://sourceforge/${PN%-*}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="http://smplayer.sourceforge.net/"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
IUSE="qt5"
DEPEND="
	!qt5? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
"
RDEPEND="
	media-video/smplayer[qt5?]
"

src_prepare() {
	sed \
		-e "s:rcc -binary:$(usex qt5 $(qt5_get_bindir) $(qt4_get_bindir))/&:" \
		-i themes/Makefile
}

src_install() {
	einstall DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
	dodoc Changelog README.txt
}
