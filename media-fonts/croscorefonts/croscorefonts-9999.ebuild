# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font git-r3

DESCRIPTION="Open licensed fonts metrically compatible with MS corefonts"
HOMEPAGE="
	http://www.google.com/webfonts/specimen/Arimo
	http://www.google.com/webfonts/specimen/Cousine
	http://www.google.com/webfonts/specimen/Tinos
"
EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttf"

src_prepare() {
	mv hinted/{Arimo,Cousine,Tinos}*.ttf .
}
