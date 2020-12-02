# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX=otf
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
	EGIT_BRANCH="dev_branch"
else
	MY_PV="5aeeff4"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit font-r1

DESCRIPTION="A monochrome emoji font designed to harmonize with other Source fonts"
HOMEPAGE="https://github.com/adobe-fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	!binary? ( dev-util/afdko )
"

src_compile() {
	rm -f SourceEmojiUnicode-BnW.otf
	use binary && return
	checkoutlinesufo SourceEmoji-BnW.ufo || die
	makeotf -f SourceEmoji-BnW.ufo -r || die
}
