# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES=( otf +ttf )
PYTHON_COMPAT=( python2_7 )
inherit versionator
SLOT="$(get_version_component_range 1-2)"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${FONT_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="0fa17d8"
	SRC_URI="
		mirror://githubcl/NDISCOVER/${FONT_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
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

DESCRIPTION="A geometric sans serif font family"
HOMEPAGE="https://github.com/NDISCOVER/${FONT_PN^}"

LICENSE="OFL-1.1"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
"
FONT_S=( master_{o,t}tf )

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	unpack ${MY_MK}.tar.gz
	mkdir src
	local _s _d
	for _s in "${S}"/Source/${PN^}*Final*.glyphs; do
		_d="${_s##*/}"
		ln -s "${_s}" src/"${_d// /}"
	done
	sed \
		-e 's:sub zedescender-cy by zedescender-cy.loclBSH\;\\012::' \
		-i src/*.glyphs
}

src_compile() {
	emake \
		-f ${MY_MK}/Makefile \
		${FONT_SUFFIX}
}
