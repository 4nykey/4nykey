# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES="otf ttf"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	inherit versionator vcs-snapshot
	MY_PV="$(get_version_component_range -2)R-ro/$(get_version_component_range 3-)R-it"
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV}
			-> ${P}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV//R}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="3c71e576827753fc395f44f4c2d91131-740f886"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"

DESCRIPTION="Monospaced font family for user interface and coding environments"
HOMEPAGE="http://adobe-fonts.github.io/${PN}"

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
		S="${WORKDIR}/${P}$(usex binary R '')"
	fi

	if use binary; then
		FONT_S=( {O,T}TF )
	else
		python-any-r1_pkg_setup
		PATCHES=(
			"${FILESDIR}"/${PN}_fonttools.diff
		)
		source /etc/afdko
	fi

	font-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		use binary || unpack ${MY_MK}.tar.gz
	else
		vcs-snapshot_src_unpack
	fi
}

src_compile() {
	use binary && return
	emake \
		${FONT_SUFFIX} \
		-f "${WORKDIR}"/${MY_MK}/Makefile
}
