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
IUSE="empty_dollar dotted_zero base_one zstyle_l no_contextual_alternates"

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

src_configure() {
	local _o=()
	use empty_dollar || _o+=(dollar.empty)
	use dotted_zero || _o+=(zero.dot)
	use base_one || _o+=(one.base)
	use zstyle_l || _o+=(l.zstyle)
	use no_contextual_alternates || _o+=(NoCalt)
	if [[ ${#_o[@]} -ne 0 ]]; then
		_o="${_o[@]}"
		sed -e "/\(${_o// /\|}\)/d" -i "${S}"/Scripts/build.py || die
	fi
}

src_compile() {
	local _d _l
	for _d in {Monoisome,Source}/*.sfdir; do
		_l="${T}/$(basename ${_d} .sfdir).log"
		ebegin "Building ${_d}"
		"${S}"/Scripts/build.py 1 0 ${_d} > "${_l}"
		eend $? || die "failed to build, see ${_l}"
	done
}
