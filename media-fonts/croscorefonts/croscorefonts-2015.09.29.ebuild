# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PV="${PV//./-}-license-adobe"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts"
else
	SRC_URI="
		mirror://github/googlei18n/noto-fonts/archive/v${MY_PV}.tar.gz
		-> noto-${PV}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/noto-fonts-${MY_PV}"
fi
inherit font

DESCRIPTION="Open licensed fonts metrically compatible with MS corefonts"
HOMEPAGE="
	http://www.google.com/webfonts/specimen/Arimo
	http://www.google.com/webfonts/specimen/Cousine
	http://www.google.com/webfonts/specimen/Tinos
"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttf"

src_prepare() {
	mv "${S}"/hinted/{Arimo,Cousine,Tinos}*.ttf "${S}"/
}
