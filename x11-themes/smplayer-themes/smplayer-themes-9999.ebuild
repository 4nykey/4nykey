# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://subversion.assembla.com/svn/${PN%-*}/${PN}/trunk/"
else
	SRC_URI="mirror://sourceforge/${PN%-*}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Icon themes for smplayer"
HOMEPAGE="https://www.smplayer.info"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 CC0-1.0 GPL-2 GPL-3+ LGPL-3"
SLOT="0"
IUSE=""
DEPEND="
	dev-qt/qtcore:5
"
RDEPEND="
	media-video/smplayer
"
DOCS=( Changelog README.txt )

src_prepare() {
	default
	sed \
		-e 's:usr/local:${EPREFIX}/usr:' \
		-e 's:install -d \$(THEMES_PATH):& $(THEMES_PATH)/../../doc/$(PF):' \
		-e '/README/s:/\([^/]\+\)/$:/../../doc/$(PF)/\1_README.txt:' \
		-i Makefile
	sed \
		-e "s:rcc -binary:$(qt5_get_bindir)/&:" \
		-i themes/Makefile
}
