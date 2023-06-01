# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttc )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}R
			-> ${P}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi
inherit font-r1

DESCRIPTION="An monospaced font for mixed Latin and Japanese text"
HOMEPAGE="https://github.com/adobe-fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"
REQUIRED_USE="
?? ( ${MY_FONT_TYPES[@]/#+/} )
"

DEPEND="
	!binary? (
		dev-util/afdko
		dev-python/opentype-svg
	)
"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	else
		use binary && S="${WORKDIR}/${P}R"
	fi
	use binary && FONT_S=( OTC OTF )
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	sed -e 's:\<exit\>:die:' -i commands*.sh
	mv -f Regular/cidfontinfo.{I,i}t
}

src_compile() {
	use binary && return
	source "${S}"/commands.sh
	if use font_types_ttc; then
		source "${S}"/commands_subroutinize_otc.sh
	else
		find -name '*.otf' -exec mv --target-directory="${FONT_S}" {} +
	fi
}
