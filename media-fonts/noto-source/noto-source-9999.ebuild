# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES=( otf +ttf )
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="b3eaf63"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-cf5cbff"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go interpolate"

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
	ln -s "${S}"/src/NotoSansDevanagari/NotoSansDevanagari{,UI}-MM.glyphs
	unpack ${MY_MK}.tar.gz
}

src_compile() {
	emake \
		-f ${MY_MK}/Makefile \
		$(usex interpolate '' 'INTERPOLATE=') \
		$(usex clean-as-you-go 'CLEAN=y' '') \
		${FONT_SUFFIX}
}
