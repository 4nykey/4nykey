# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

HOMEPAGE="http://opensans.com"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN/-}.git"
	FONT_S=( hinted_ttfs )
else
	SRC_URI="
		${HOMEPAGE}/download/${PN}.zip
		${HOMEPAGE}/download/${PN}-condensed.zip
	"
	RESTRICT="primaryuri"
	S="${WORKDIR}"
	KEYWORDS="~amd64 ~x86"
	DEPEND="app-arch/unzip"
fi
inherit font-r1

DESCRIPTION="A clean and modern sans-serif typeface for web, print and mobile"

LICENSE="Apache-2.0"
SLOT="0"
