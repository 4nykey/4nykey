# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FONT_SUFFIX="ttf"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/vernnobile/OswaldFont.git"
	DOCS="README"
	FONT_SUFFIX="${FONT_SUFFIX} otf"
else
	S="${WORKDIR}"
	inherit unpacker font
	SRC_URI="
	http://www.google.com/fonts/download?kit=GQYw7JiK-3VkBS1KVOUJP_esZW2xOQ-xsNqO47m55DA
	-> ${P}.zip
	"
	RESTRICT="primaryuri"
	DEPEND="$(unpacker_src_uri_depends)"
fi

DESCRIPTION="Oswald is a reworking of the classic gothic typeface"
HOMEPAGE="http://oswaldfont.com"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
		find "${S}"/${PV%.*} -type f -name '*.[ot]tf' -exec mv {} "${S}" \;
		rm -f *unhinted.ttf
	fi
}
