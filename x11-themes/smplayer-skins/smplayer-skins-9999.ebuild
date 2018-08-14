# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://subversion.assembla.com/svn/${PN%-*}/${PN}/trunk/"
else
	SRC_URI="mirror://sourceforge/${PN%-*}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Skins for SMPlayer"
HOMEPAGE="https://www.smplayer.info"

LICENSE="CC-BY-2.5 CC-BY-SA-2.5 CC-BY-SA-3.0 GPL-2 LGPL-3"
SLOT="0"
IUSE=""
DEPEND="
	dev-qt/qtcore:5
"
RDEPEND="
	media-video/smplayer
"

src_prepare() {
	default
	sed \
		-e "s:rcc -binary:$(qt5_get_bindir)/&:" \
		-i themes/Makefile
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
	dodoc Changelog README.txt
}
