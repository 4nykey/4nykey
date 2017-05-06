# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fontmake.eclass
# @MAINTAINER:
# 4nykey@gmail.com
# @BLURB: An eclass to build fonts from sources using dev-util/fontmake

# @VARIABLE: myemakeargs
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional emake defines as a bash array

# @VARIABLE: FONTDIR_BIN
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of dirs to search for prebuilt fonts in
FONTDIR_BIN=( ${FONTDIR_BIN[@]:-fonts} )

PYTHON_COMPAT=( python2_7 )
IUSE="+binary"

inherit python-any-r1 font-r1

EXPORT_FUNCTIONS pkg_setup src_prepare src_compile

MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-c49fb69"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
RESTRICT="primaryuri"

DEPEND="
!binary? (
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
	sys-apps/rename
)
"

fontmake_pkg_setup() {
	if use binary; then
		local _d
		FONT_S=( "${FONTDIR_BIN[@]}" )
		PATCHES=( )
	else
		FONT_S=( master_{o,t}tf )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

fontmake_src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	find -name '* *.glyphs' -execdir renamexm -s'/ //g' {} \;
}

fontmake_src_compile() {
	use binary && return
	emake \
		-f ${MY_MK}/Makefile \
		"${myemakeargs[@]}" \
		${FONT_SUFFIX}
}
