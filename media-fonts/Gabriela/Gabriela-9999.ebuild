# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/etunni/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="cb21c6e"
	SRC_URI="
		mirror://githubcl/etunni/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A serif typeface with soft shapes and terminal forms shaped like curls"
HOMEPAGE="https://github.com/etunni/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	if use binary; then
		FONT_S=( fonts )
		FONT_SUFFIX="ttf"
	else
		FONT_S=( master_{o,t}tf )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || \
	sed \
		-e 's:color = (:colorObject = (:' \
		-i "${S}"/sources/${PN}*.glyphs
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/sources/${PN}.glyphs \
		-o ${FONT_SUFFIX} \
		|| die
}
