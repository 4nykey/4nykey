# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
inherit versionator
SLOT="$(get_version_component_range 1-2)"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${FONT_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="27e0ea4"
	SRC_URI="
		mirror://githubcl/NDISCOVER/${FONT_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A geometric sans serif font family"
HOMEPAGE="https://github.com/NDISCOVER/${FONT_PN^}"

LICENSE="OFL-1.1"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
"
FONT_S=( instance_{o,t}tf )

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_compile() {
	local _g
	for _g in "${S}"/Source/${PN^}*.glyphs; do
		fontmake \
			--glyphs-path "${_g}" \
			--masters-as-instances \
			-o ${FONT_SUFFIX} \
			|| die
	done
}
