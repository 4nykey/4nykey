# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/i-tu/${PN}"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="${PV//_/-}"
	SRC_URI="
		binary? (
			https://github.com/i-tu/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV/b/B}.zip
		)
		!binary? (
			mirror://githubcl/i-tu/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font
MY_MK="3c71e576827753fc395f44f4c2d91131-4e1e133"
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

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/afdko[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""

FONT_SUFFIX="otf"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		FONT_S="${S}"
	else
		python-any-r1_pkg_setup
		source /etc/afdko
	fi
	font_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		use binary || unpack ${MY_MK}.tar.gz
	else
		vcs-snapshot_src_unpack
	fi
}

src_compile() {
	use binary || \
		emake -f "${WORKDIR}"/${MY_MK}/Makefile family=${PN}
}
