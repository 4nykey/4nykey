# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/Raleway.git"
else
	inherit vcs-snapshot
	MY_PV="a48dcf5"
	SRC_URI="
		mirror://githubcl/impallari/Raleway/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="Raleway is an elegant sans-serif typeface"
HOMEPAGE="http://www.impallari.com/projects/overview/matt-mcinerneys-raleway-family"

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
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="CONTRIBUTORS.txt FONTLOG.txt README.md"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	default
	use binary && mv "${S}/fonts/OTF v${PV} Glyphs"/*.otf "${FONT_S}"
}

src_compile() {
	use binary && return

	local _g
	for _g in "${S}"/source/*.glyphs; do
		_d="$(basename ${_g})"
		_d="${S}/${_d//[^a-zA-Z]/_}"
		mkdir -p "${_d}"
		pushd "${_d}" > /dev/null
		fontmake \
			--output otf \
			--interpolate \
			--glyphs-path "${_g}" || die
		mv "${_d}"/instance_otf/*.otf "${FONT_S}"
		popd > /dev/null
	done
}
