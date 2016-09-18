# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
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

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://www.mozilla.org/en-US/styleguide/products/firefox-os/typeface/"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary interpolate"

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
FONT_SUFFIX="otf"
DOCS="*.md"

pkg_setup() {
	if use !binary; then
		PATCHES=( "${FILESDIR}" )
		python-any-r1_pkg_setup
	fi
	FONT_S="${S}/$(usex binary otf instance_otf)"
	font_pkg_setup
}

src_compile() {
	use binary && return
	local _g
	for _g in "${S}"/source/glyphs/${PN}*.glyphs; do
		fontmake \
			--glyphs-path "${_g}" \
			--output otf \
			$(usex interpolate '--interpolate' '--masters-as-instances') \
			|| die
	done
}
