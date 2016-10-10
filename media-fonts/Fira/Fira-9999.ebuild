# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mozilla/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/mozilla/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-0251c9f"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://www.mozilla.org/en-US/styleguide/products/firefox-os/typeface/"

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
			dev-util/afdko[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="
	!media-fonts/fira-mono
	!media-fonts/fira-sans
"
DOCS="*.md"

pkg_setup() {
	if use !binary; then
		PATCHES=( "${FILESDIR}"/${PN}-glyphslib.diff )
		python-any-r1_pkg_setup
	fi
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	font_pkg_setup
	. /etc/afdko
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
	use binary && return
	sed \
		-e 's:active = 0\;:exports = 0\;:' \
		-e 's:WORK_::' \
		-i "${S}"/source/glyphs/${PN}*.glyphs
	ln -s source/glyphs src
}

src_compile() {
	if use binary; then
		mv -f "${S}"/[ot]tf/*.[ot]tf "${S}"/
	else
		local t=" -o ${FONT_SUFFIX}"
		[[ ${#t} -eq 8 ]] || t=
		emake \
			FONTMAKE="fontmake${t}" \
			INTERPOLATE='makeInstancesUFO -a -c -n -dec -d' \
			-f "${WORKDIR}"/${MY_MK}/Makefile
		for t in ${FONT_SUFFIX}; do
			mv -f "${S}"/master_${t}/*.${t} "${S}"/
		done
	fi
}
