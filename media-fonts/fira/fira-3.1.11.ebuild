# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/mozilla/Fira.git"
	DOCS="README*"
else
	MY_P="FiraFonts${PV//./}"
	S="${WORKDIR}/${MY_P}"
	inherit versionator unpacker font
	SRC_URI="http://www.carrois.com/wordpress/downloads/$(version_format_string '${PN}_$1_$2')/${MY_P}.zip"
	RESTRICT="primaryuri"
	DEPEND="$(unpacker_src_uri_depends)"
fi

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://www.mozilla.org/en-US/styleguide/products/firefox-os/typeface/"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${DEPEND}"
FONT_SUFFIX="otf ttf"

src_prepare() {
	find "${S}" -type f -name '*.[ot]tf' -exec mv {} . \;
}
