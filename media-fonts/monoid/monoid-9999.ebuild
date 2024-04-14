# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
MY_FONT_VARIANTS="loose halfloose halftight tight xtrasmall small large xtralarge"
MY_FONT_CHARS="empty_dollar dotted_zero base_one zstyle_l no_contextual_alternates"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/larsenwork/${PN}.git"
else
	MY_PV="0673c8d"
	SRC_URI="
		mirror://githubcl/larsenwork/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit python-single-r1 font-r1 multiprocessing

DESCRIPTION="Customisable coding font with alternates, ligatures and contextual positioning"
HOMEPAGE="https://larsenwork.com/monoid"

LICENSE="MIT OFL-1.1"
SLOT="0"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
	')
"

FONT_S=( _release )
DOCS="Readme.md"

pkg_setup() {
	python-single-r1_pkg_setup
	font-r1_pkg_setup
}

src_configure() {
	local _o
	use font_chars_empty_dollar || _o+="dollar.empty\|"
	use font_chars_dotted_zero || _o+="zero.dot\|"
	use font_chars_base_one || _o+="one.base\|"
	use font_chars_zstyle_l || _o+="l.zstyle\|"
	use font_chars_no_contextual_alternates || _o+="NoCalt\|"
	use font_variants_loose || _o+="\<Loose\>\|"
	use font_variants_halfloose || _o+="HalfLoose\|"
	use font_variants_tight || _o+="\<Tight\>\|"
	use font_variants_halftight || _o+="HalfTight\|"
	use font_variants_xtrasmall || _o+="XtraSmall\|"
	use font_variants_small || _o+="\<Small\>\|"
	use font_variants_large || _o+="\<Large\>\|"
	use font_variants_xtralarge || _o+="XtraLarge\|"
	if [[ -n ${_o} ]]; then
		sed -e "/\(${_o%|})/d" -i "${S}"/Scripts/build.py || die
	fi
}

src_compile() {
	local _d
	for _d in {Monoisome,Source}/*.sfdir; do
		set -- fontforge -script ./Scripts/build.py $(makeopts_jobs) 0 "${_d}"
		ebegin "${@}"
		"${@}"
		eend $? || die "failed to build ${_d}"
	done
}
