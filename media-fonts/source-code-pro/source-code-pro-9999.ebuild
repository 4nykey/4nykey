# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	MY_PVB="678cc31"
	MY_PV="024350a"
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PVB}
			-> ${P%_p*}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="Monospaced font family for user interface and coding environments"
HOMEPAGE="https://adobe-fonts.github.io/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary variable"

BDEPEND="
	!binary? (
		dev-util/afdko
		dev-python/opentype-svg
		variable? ( dev-util/fontmake )
	)
"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	else
		S="${WORKDIR}/${PN}-$(usex binary ${MY_PVB} ${MY_PV})"
	fi

	FONT_S=( $(usex binary . target)/$(usex variable VAR $(usex font_types_otf OTF TTF)) )

	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	sed \
		-e 's:"\$addSVG" \(.*\) \(.*\)$:addsvg -s \2 \1:' \
		-i build*.sh
}

src_compile() {
	use binary && return
	. ./build$(usex variable 'VFs' '').sh || die
}
