# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
FONT_TYPES_EXCLUDE="ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${PN}"
else
	inherit vcs-snapshot
	MY_PV="6c67ab1"
	SRC_URI="
		mirror://githubcl/impallari/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-f363b48"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"
RESTRICT="primaryuri"

DESCRIPTION="An elegant sans-serif typeface"
HOMEPAGE="http://www.impallari.com/projects/overview/matt-mcinerneys-raleway-family"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"
REQUIRED_USE="binary? ( !font_types_ttf )"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		FONT_S=( fonts/v${PV//.} )
	else
		FONT_S=( master_{o,t}tf )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	local _g
	for _g in "${S}"/source/*.glyphs; do mv -f "${_g}" "${_g// /}"; done
}

src_compile() {
	use binary && return
	emake \
		SRCDIR="${S}/source" \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		-f ${MY_MK}/Makefile
}
