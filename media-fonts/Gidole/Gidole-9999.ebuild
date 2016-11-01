# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/larsenwork/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="af00170"
	SRC_URI="
		mirror://githubcl/larsenwork/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"
inherit python-any-r1 font-r1

DESCRIPTION="Open Source Modern DIN"
HOMEPAGE="http://gidole.github.io"

LICENSE="MIT OFL-1.1"
SLOT="0"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		media-gfx/fontforge[${PYTHON_USEDEP}]
	')
"
DOCS="ReadMe.md"

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	unpack ${MY_MK}.tar.gz
}

src_compile() {
	local _t
	for _t in ${FONT_SUFFIX}; do
		fontforge -script ${MY_MK}/ffgen.py Source/Gidole-Regular.sfdir \
			${_t} || die
	done
}
