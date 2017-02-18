# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/huertatipografica/${PN}.git"
	EGIT_BRANCH="dev"
else
	inherit vcs-snapshot
	MY_PV="bed47b9"
	SRC_URI="
		mirror://githubcl/huertatipografica/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-cf5cbff"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"
RESTRICT="primaryuri"

DESCRIPTION="A serif typeface originally intended for literature"
HOMEPAGE="https://github.com/huertatipografica/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
"
FONT_S=( master_{o,t}tf )
DOCS="*.txt"
PATCHES=(
	"${FILESDIR}"/${PN}_toomanyalignmentzones.diff
)

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	unpack ${MY_MK}.tar.gz
	local _g
	for _g in "${S}"/*\ *.glyphs; do mv -f "${_g}" "${_g// /}"; done
}

src_compile() {
	emake \
		-f ${MY_MK}/Makefile \
		SRCDIR="." \
		${FONT_SUFFIX}
}
