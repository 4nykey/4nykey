# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EbenSorkin/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="f312a66"
	SRC_URI="
		binary? (
			https://github.com/EbenSorkin/${PN}/releases/download/${PV}/${P}.zip
		)
		!binary? (
			mirror://githubcl/EbenSorkin/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/EbenSorkin/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

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
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	if use binary; then
		S="${WORKDIR}"
		FONT_S="${S}"
	else
		FONT_S="${S}/SRC"
		DOCS+=" README.md"
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	if use binary; then
		mv -f "${S}"/[OT]TF/${PN}*.[ot]tf "${FONT_S}"/
	else
		local t u
		for u in "${FONT_S}"/${PN}*.ufo; do
		for t in ${FONT_SUFFIX}; do
			fontforge -quiet -lang=py -c \
			'from sys import argv;\
			f=fontforge.open(argv[1]);\
			f.encoding="UnicodeFull";\
			f.selection.all();\
			f.generate(argv[2],flags=("opentype"));\
			f.close()' \
			"${u}" "${u%.ufo}.${t}" || die
		done
		done
	fi
}
