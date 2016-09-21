# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tonsky/${PN}"
else
	SRC_URI="mirror://githubcl/tonsky/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
FONT_SUFFIX="otf"
inherit python-any-r1 font

DESCRIPTION="A monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="${DEPEND}"
FONT_SUFFIX="otf"
DOCS=( README.md )

pkg_setup() {
	if use binary; then
		FONT_S="${S}/distr/otf"
	else
		FONT_S="${S}/instance_otf"
		python-any-r1_pkg_setup
	fi
	font_pkg_setup
}

src_prepare() {
	use binary && return
	default
	sed -e 's:\\\\::g' -i FiraCode.glyphs || die
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/${PN}.glyphs \
		--output otf \
		--interpolate \
		|| die
}
