# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/fonts"
	FONT_S=( apache/opensans{,condensed,hebrew,hebrewcondensed} )
else
	SRC_URI="
		http://www.opensans.com/download/open-sans.zip
		http://www.opensans.com/download/open-sans-condensed.zip
	"
	RESTRICT="primaryuri"
	S="${WORKDIR}"
	KEYWORDS="~amd64 ~x86"
	DEPEND="app-arch/unzip"
fi
inherit font-r1

DESCRIPTION="A clean and modern sans-serif typeface for web, print and mobile"
HOMEPAGE="http://opensans.com/"

LICENSE="Apache-2.0"
SLOT="0"
