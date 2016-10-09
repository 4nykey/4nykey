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
	inherit vcs-snapshot
	MY_PV="03b7185"
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV%_p*}R
			-> ${P}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font
MY_MK="3c71e576827753fc395f44f4c2d91131-740f886"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"

DESCRIPTION="Serif typeface designed to complement Source Sans Pro"
HOMEPAGE="http://adobe-fonts.github.io/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/afdko[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""

DOCS="README.md"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done

	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	else
		S="${WORKDIR}/${P}$(usex binary R '')"
		FONT_S="${S}"
	fi

	font_pkg_setup

	use binary && return
	python-any-r1_pkg_setup
	DOCS="${DOCS} relnotes.txt"
	source /etc/afdko
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		use binary || unpack ${MY_MK}.tar.gz
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	default
	use binary && mv "${S}"/[OT]TF/*.[ot]tf "${FONT_S}"
}

src_compile() {
	use binary && return
	emake \
		${FONT_SUFFIX} \
		-f "${WORKDIR}"/${MY_MK}/Makefile
}
