# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/vernnobile/OswaldFont.git"
else
	inherit vcs-snapshot font
	SRC_URI="
		mirror://github/vernnobile/OswaldFont/archive/9dd0521c8c06dd24998fe5d9cd644dab9cbbacca.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="Oswald is a reworking of the classic gothic typeface"
HOMEPAGE="http://oswaldfont.com"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"
FONT_SUFFIX="ttf otf"
DOCS="README*"

src_prepare() {
		find "${S}"/${PV%.*} -type f -name '*.[ot]tf' -exec mv {} "${S}" \;
		rm -f *unhinted.ttf
}
