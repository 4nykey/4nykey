# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/code"
else
	SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A program for making font samples that show Unicode coverage of the font"
HOMEPAGE="https://sourceforge.net/projects/${PN}"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype:2
	x11-libs/cairo
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	app-i18n/unicode-data
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-unicode-blocks="/usr/share/unicode-data/Blocks.txt"
}
