# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="Raleway"
FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${MY_PN}"
else
	inherit vcs-snapshot
	MY_PV="a48dcf5"
	SRC_URI="
		mirror://githubcl/impallari/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-8e4962a"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"

DESCRIPTION="Raleway is an elegant sans-serif typeface"
HOMEPAGE="http://www.impallari.com/projects/overview/matt-mcinerneys-raleway-family"

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

DOCS+=" CONTRIBUTORS.txt README.md"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	if use binary; then
		FONT_S="${S}/fonts"
	else
		python-any-r1_pkg_setup
	fi
	font_pkg_setup
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		use binary || unpack ${MY_MK}.tar.gz
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	default
	use binary && mv "${S}/fonts/OTF v4.010 Glyphs"/*.otf "${FONT_S}"
}

src_compile() {
	use binary && return
	emake \
		SRCDIR="${S}/source" \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		-f "${WORKDIR}"/${MY_MK}/Makefile
	for t in ${FONT_SUFFIX}; do
		mv -f "${S}"/master_${t}/*.${t} "${S}"/
	done
}
