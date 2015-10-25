# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://github.com/mozilla/Fira.git"
	DOCS="README*"
else
	inherit font vcs-snapshot
	BASE_URI="http://www.carrois.com/downloads/"
	SRC_URI="
		mirror://githubcl/mozilla/Fira/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	DOCS="*.md"
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
