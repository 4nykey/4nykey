# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/smplayer-themes/smplayer-themes-14.9.0.ebuild,v 1.4 2014/09/29 10:05:13 ago Exp $

EAPI=5

inherit subversion

DESCRIPTION="Icon themes for smplayer"
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
DOCS=( Changelog README.txt )

src_prepare() {
	sed \
		-e 's:usr/local:${EPREFIX}/usr:' \
		-e 's:install -d \$(THEMES_PATH):& $(THEMES_PATH)/../../doc/$(PF):' \
		-e '/README/s:/\([^/]\+\)/$:/../../doc/$(PF)/\1_README.txt:' \
		-i Makefile
}
