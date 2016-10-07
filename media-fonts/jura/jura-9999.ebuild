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
	MY_PV="5618dd4"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="A family of sans-serif fonts in the Eurostile vein"
HOMEPAGE="http://danieljohnson.name/fonts/jura https://github.com/alexeiva/jura"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""
DOCS+=" README.md"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_compile() {
	if use binary; then
		mv -f "${S}"/fonts/[ot]tf/*.[ot]tf "${S}"/
	else
		local t=" -o ${FONT_SUFFIX}"
		[[ ${#t} -eq 8 ]] || t=
		fontmake \
			--glyphs-path sources/Jura.glyphs \
			--masters-as-instances \
			${t} \
			|| die
		for t in ${FONT_SUFFIX}; do
			mv -f "${S}"/instance_${t}/*.${t} "${S}"/
		done
	fi
}
