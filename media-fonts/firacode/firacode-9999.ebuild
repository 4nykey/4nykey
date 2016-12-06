# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tonsky/${PN}"
else
	SRC_URI="mirror://githubcl/tonsky/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-ce43005"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
RESTRICT="primaryuri"

DESCRIPTION="A monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/${PN}"

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
		FONT_S=( distr/{o,t}tf )
	else
		python-any-r1_pkg_setup
		FONT_S=( master_{o,t}tf )
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	sed -e 's:\\\\::g' -i FiraCode.glyphs || die
	unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	emake \
		SRCDIR="${S}" \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		RM=true \
		-f ${MY_MK}/Makefile
}
