# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_SUFFIX=otf
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	inherit vcs-snapshot
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
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="An monospaced font for mixed Latin and Japanese text"
HOMEPAGE="https://github.com/adobe-fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/afdko[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	else
		S="${WORKDIR}/${P}$(usex binary 'R' '')"
	fi
	if use binary; then
		FONT_S=( OTF )
	else
		python-any-r1_pkg_setup
		FONT_S=( Bold ExtraLight Heavy Light Medium Normal Regular )
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || \
	sed -e 's:\<exit\>:die:' -i commands.sh
}

src_compile() {
	use binary && return
	source "${S}"/commands.sh
}
