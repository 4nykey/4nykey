# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES="otf ttf"
MY_PN="Inconsolata-LGC"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/glebd/${MY_PN}.git"
	EGIT_BRANCH="tight"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="LGC-${PV}"
	SRC_URI="
	binary? (
		font_types_otf? (
			https://github.com/MihailJP/${MY_PN}/releases/download/${MY_PV}/${MY_PN/-}-OT-${PV}.tar.xz
		)
		font_types_ttf? (
			https://github.com/MihailJP/${MY_PN}/releases/download/${MY_PV}/${MY_PN/-}-${PV}.tar.xz
		)
	)
	!binary? (
		mirror://githubcl/MihailJP/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
fi
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"
RESTRICT="primaryuri"
inherit python-any-r1 font-r1

DESCRIPTION="A version of Inconsolata with Greek and Cyrillic support"
HOMEPAGE="https://github.com/MihailJP/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		FONT_S=( ${MY_PN/-}{-OT,}-${PV} )
	else
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	local _t _s
	for _t in ${FONT_SUFFIX}; do
		for _s in "${S}"/${MY_PN}*.sfd; do
				fontforge -script ${MY_MK}/ffgen.py "${_s}" ${_t}
		done
	done
}
