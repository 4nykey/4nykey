# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
MY_PN="${PN/-}"
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
if [[ -z ${PV%%*9999} ]]; then
	EBZR_REPO_URI="lp:${MY_PN}"
	inherit bzr
	FONT_TYPES="otf ttf"
else
	MY_P="${MY_PN}-${PV}"
	SRC_URI="https://launchpad.net/${MY_PN}/trunk/${PV}/+download/${MY_P}.zip"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
	REQUIRED_USE="binary"
fi
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
inherit python-any-r1 font-r1

DESCRIPTION="A realist sans-serif typeface based on ATF 1908 News Gothic"
HOMEPAGE="http://www.glyphography.com/fonts/"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use !binary; then
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	rm -f "${S}"/*.[ot]tf
	unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	local _t _u
	for _u in src/NewsCycle-{Bold,Regular,Regular-Italic}.sfd; do
	for _t in ${FONT_SUFFIX}; do
		fontforge -script ${MY_MK}/ffgen.py "${_u}" ${_t} || die
	done
	done
}
