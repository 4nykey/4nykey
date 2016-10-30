# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	SRC_URI="
		mirror://githubcl/googlei18n/${MY_CJK%-*}/tar.gz/v${MY_CJK##*-}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
CHECKREQS_DISK_BUILD="930M"
inherit check-reqs font-r1

DESCRIPTION="Noto CJK fonts"
HOMEPAGE="http://www.google.com/get/noto/help/cjk"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""
FONT_S=( inst )

src_prepare() {
	default
	mkdir -p "${FONT_S}"/
	mv "${S}"/NotoSans[JKST]*.otf "${FONT_S}"/
}
