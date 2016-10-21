# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="0de0a11"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/EbenSorkin/${PN}"

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

DOCS+=" README.md"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	default
	sed \
		-e 's:color = (:colorObject = (:' \
		-i "${S}"/sources/${PN}*.glyphs
}

src_compile() {
	if use binary; then
		mv -f "${S}"/fonts/[ot]tf/*.[ot]tf "${S}"/
	else
		local g t=" -o ${FONT_SUFFIX}"
		[[ ${#t} -eq 8 ]] || t=
		for g in "${S}"/sources/${PN}*.glyphs; do
			fontmake \
				--glyphs-path "${g}" \
				--interpolate \
				${t} \
				|| die
		done
		for t in ${FONT_SUFFIX}; do
			mv -f "${S}"/instance_${t}/*.${t} "${S}"/
		done
	fi
}
