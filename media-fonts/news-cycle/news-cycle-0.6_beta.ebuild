# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES=( otf +ttf )
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-}"
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
inherit python-any-r1 font-r1

DESCRIPTION="A realist sans-serif typeface based on ATF 1908 News Gothic"
HOMEPAGE="http://www.glyphography.com/fonts/"
SRC_URI="
${HOMEPAGE}${MY_PN}-regular-${PV#*_}-${PV%_*}.ufo.zip
${HOMEPAGE}${MY_PN}-italic-${PV#*_}-${PV%_*}.ufo.zip
mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
-> ${MY_MK}.tar.gz
"
RESTRICT="primaryuri"
KEYWORDS=""
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"

DEPEND="
	app-arch/unzip
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		media-gfx/fontforge[python,${PYTHON_USEDEP}]
	')
"

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_compile() {
	local _t _u
	for _u in "${S}"/${MY_PN}*.ufo; do
	for _t in ${FONT_SUFFIX}; do
		fontforge -script "${WORKDIR}"/${MY_MK}/ffgen.py "${_u}" ${_t} || die
	done
	done
}
