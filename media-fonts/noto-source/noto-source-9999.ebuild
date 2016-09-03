# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="7317096"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 multiprocessing font

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="interpolate multiprocessing"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="*.md"
PATCHES=( "${FILESDIR}"/${PN}_build.diff )

pkg_setup() {
	python-any-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	default
	use interpolate || sed \
		-e '/fontmake/ s: -i : :' \
		-i build.sh
}

src_compile() {
	if use multiprocessing; then
		local g
		multijob_init
		for g in src/*.glyphs src/*/*.plist; do
			multijob_pre_fork
			(
				multijob_child_init
				/bin/bash ./build.sh build_one "${g}" || \
				echo -n " ${g}" >> "${T}"/_failed
			) &
		done
		multijob_finish
	else
		default
	fi
	find -mindepth 3 -maxdepth 3 -name '*.otf' -! -size 0 -exec mv -f {} "${S}" \;
	[[ -e ${T}/_failed ]] && \
		ewarn "These fonts failed to build:$(<${T}/_failed)"
}
