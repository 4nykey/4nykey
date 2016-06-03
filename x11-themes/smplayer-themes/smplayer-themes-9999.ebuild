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

DESCRIPTION="Icon themes for smplayer"
HOMEPAGE="http://smplayer.sourceforge.net/"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
IUSE="qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"
DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
"
RDEPEND="
	media-video/smplayer[qt4?,qt5?]
	!x11-themes/papirus-suite[smplayer]
"
DOCS=( Changelog README.txt )

src_prepare() {
	sed \
		-e 's:usr/local:${EPREFIX}/usr:' \
		-e 's:install -d \$(THEMES_PATH):& $(THEMES_PATH)/../../doc/$(PF):' \
		-e '/README/s:/\([^/]\+\)/$:/../../doc/$(PF)/\1_README.txt:' \
		-i Makefile
	sed \
		-e "s:rcc -binary:$(usex qt4 $(qt4_get_bindir) $(qt5_get_bindir))/&:" \
		-i themes/Makefile
}
