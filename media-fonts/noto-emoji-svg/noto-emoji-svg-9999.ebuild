# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
FONT_SUFFIX=otf
FONT_S=( fonts )
inherit python-any-r1 font-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	MY_PV="ed5c78c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="OpenType-SVG version of Noto Color Emoji"
HOMEPAGE="https://github.com/adobe-fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
!binary? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/fonttools[${PYTHON_USEDEP}]
	')
	dev-util/afdko
)
"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	sed -e "s:\<python3\>:${PYTHON}:" -i build.sh
	./build.sh ${PV%_p*} || die
}
