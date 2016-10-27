# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="0345032"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-0251c9f"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
interpolate
$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
"

FONT_S=( master_{o,t}tf )

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		unpack ${MY_MK}.tar.gz
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	default
	ln -s "${S}"/src/NotoSansDevanagari/NotoSansDevanagari{,UI}-MM.glyphs
}

src_compile() {
	emake \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		INTERPOLATE="$(usex interpolate 'fontmake -o ufo -i -m' '')" \
		-f "${WORKDIR}"/${MY_MK}/Makefile
}
