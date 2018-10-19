# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fontmake.eclass
# @MAINTAINER:
# 4nykey@gmail.com
# @BLURB: An eclass to build fonts from sources using dev-util/fontmake

# @VARIABLE: FONT_SRCDIR
# @DESCRIPTION:
# The path of a directory containing the sources, relative to ${S}.
# 'sources' if unset
FONT_SRCDIR=${FONT_SRCDIR:-sources}

# @VARIABLE: FONTMAKE_EXTRA_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing additional arguments for fontmake.

# @VARIABLE: EMAKE_EXTRA_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array containing additional arguments for emake.

# @VARIABLE: FONTDIR_BIN
# @DESCRIPTION:
# An array containing paths relative to ${S}, where to search for prebuilt
# fonts. By default: 'fonts fonts/otf fonts/ttf'
FONTDIR_BIN=( ${FONTDIR_BIN[@]:-fonts fonts/otf fonts/ttf} )

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
IUSE="autohint +binary"
MY_FONT_TYPES=( ${MY_FONT_TYPES[@]:-otf +ttf} )

inherit python-any-r1 font-r1

EXPORT_FUNCTIONS pkg_setup src_prepare src_compile

MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-7f9cf67"
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
	autohint? ( media-gfx/ttfautohint )
)
"

fontmake_pkg_setup() {
	if use binary; then
		local _d
		FONT_S=( "${FONTDIR_BIN[@]}" )
		PATCHES=( )
	else
		FONT_S=( master_{o,t}tf autohinted/master_ttf )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

fontmake_src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	local _g
	find "${FONT_SRCDIR}" -name '* *.glyphs' -o -name '* *.designspace'| \
		while read _g; do mv "${_g}" "${_g// }"; done
}

fontmake_src_compile() {
	use binary && return

	local myemakeargs=(
		--no-builtin-rules
		-f ${MY_MK}/Makefile
		SRCDIR="${FONT_SRCDIR}"
		"${EMAKE_EXTRA_ARGS[@]}"
		$(in_iuse interpolate && usex interpolate '' 'INTERPOLATE=')
		$(in_iuse clean-as-you-go && usex clean-as-you-go 'CLEAN=clean' '')
	)
	use autohint && FONTMAKE_EXTRA_ARGS+=( --autohint )
	[[ "${#FONTMAKE_EXTRA_ARGS[@]}" -ge 1 ]] && \
	myemakeargs+=(
		FONTMAKE="fontmake ${FONTMAKE_EXTRA_ARGS[@]}"
	)

	emake "${myemakeargs[@]}" ${FONT_SUFFIX}
}
