# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/larsenwork/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="e9d77ec"
	SRC_URI="
		mirror://githubcl/larsenwork/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="Customisable coding font with alternates, ligatures and contextual positioning"
HOMEPAGE="http://larsenwork.com/monoid"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
WIDTHS="loose halfloose halftight tight"
HEIGHTS="xtrasmall small large xtralarge"
CHARS="empty_dollar dotted_zero base_one zstyle_l no_contextual_alternates"
IUSE="
$(printf 'monoid_widths_%s ' ${WIDTHS})
$(printf 'monoid_heights_%s ' ${HEIGHTS})
$(printf 'monoid_chars_%s ' ${CHARS})
"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		media-gfx/fontforge[${PYTHON_USEDEP}]
	')
"
RDEPEND=""

FONT_SUFFIX="ttf"
FONT_S="${S}/_release"
DOCS="Readme.md"

pkg_setup() {
	python-any-r1_pkg_setup
	font_pkg_setup
}

src_configure() {
	local _o
	use monoid_chars_empty_dollar || _o+="dollar.empty\|"
	use monoid_chars_dotted_zero || _o+="zero.dot\|"
	use monoid_chars_base_one || _o+="one.base\|"
	use monoid_chars_zstyle_l || _o+="l.zstyle\|"
	use monoid_chars_no_contextual_alternates || _o+="NoCalt\|"
	use monoid_widths_loose || _o+="\<Loose\>\|"
	use monoid_widths_halfloose || _o+="HalfLoose\|"
	use monoid_widths_tight || _o+="\<Tight\>\|"
	use monoid_widths_halftight || _o+="HalfTight\|"
	use monoid_heights_xtrasmall || _o+="XtraSmall\|"
	use monoid_heights_small || _o+="\<Small\>\|"
	use monoid_heights_large || _o+="\<Large\>\|"
	use monoid_heights_xtralarge || _o+="XtraLarge\|"
	if [[ -n ${_o} ]]; then
		sed -e "/\(${_o%|})/d" -i "${S}"/Scripts/build.py || die
	fi
}

src_compile() {
	local _d _l
	for _d in {Monoisome,Source}/*.sfdir; do
		_l="${T}/$(basename ${_d} .sfdir).log"
		ebegin "Building ${_d}"
		${PYTHON} "${S}"/Scripts/build.py 1 0 ${_d} > "${_l}"
		eend $? || die "failed to build, see ${_l}"
	done
}
