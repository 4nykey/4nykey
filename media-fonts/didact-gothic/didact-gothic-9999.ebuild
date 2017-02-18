# Copyright 1999-2017 Gentoo Foundation
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
	MY_PV="2720aa5"
	SRC_URI="
		mirror://githubcl/ossobuffo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-cf5cbff"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
RESTRICT="primaryuri"

DESCRIPTION="A sans-serif typeface similar to the one often used in elementary classrooms"
HOMEPAGE="http://danieljohnson.name/fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

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
		FONT_S=( fonts )
	else
		python-any-r1_pkg_setup
		FONT_S=( master_{o,t}tf )
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	local _g
	for _g in "${S}"/sources/*.glyphs; do mv -f "${_g}" "${_g// /}"; done
}

src_compile() {
	use binary && return
	emake \
		-f ${MY_MK}/Makefile \
		SRCDIR="sources" \
		${FONT_SUFFIX}
}
