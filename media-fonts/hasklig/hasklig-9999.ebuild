# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
MY_FONT_TYPES=( otf +ttf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/i-tu/${PN}"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="${PV//_/-}"
	SRC_URI="
		binary? (
			https://github.com/i-tu/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.zip
		)
		!binary? (
			mirror://githubcl/i-tu/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="3c71e576827753fc395f44f4c2d91131-c8548da"
SRC_URI+="
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"

DESCRIPTION="A code font with monospaced ligatures"
HOMEPAGE="https://github.com/i-tu/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"
REQUIRED_USE+="
	binary? ( !font_types_ttf )
"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/afdko[${PYTHON_USEDEP}]
		')
		dev-python/opentype-svg
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
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
	emake \
		${FONT_SUFFIX} \
		-f ${MY_MK}/Makefile
}
