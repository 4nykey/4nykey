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
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-8e4962a"
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
IUSE="clean-as-you-go +binary interpolate"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="
	!media-fonts/fira-mono
	!media-fonts/fira-sans
"
DOCS="*.md"

pkg_setup() {
	if use binary; then
		FONT_S=( {o,t}tf )
	else
		FONT_S=( master_{o,t}tf )
		PATCHES=( "${FILESDIR}"/${PN}-glyphslib.diff )
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	sed \
		-e '/\(active\|export\) = 0/d' \
		-e 's:WORK_::' \
		-i "${S}"/source/glyphs/${PN}*.glyphs
	sed \
		-f "${FILESDIR}"/onefamily.sed \
		-i "${S}"/source/glyphs/${PN}Sans*.glyphs
}

src_compile() {
	use binary && return
	emake \
		SRCDIR="${S}/source/glyphs" \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		$(usex interpolate '' 'INTERPOLATE=') \
		$(usex clean-as-you-go '' 'RM=true') \
		-f ${MY_MK}/Makefile
}
