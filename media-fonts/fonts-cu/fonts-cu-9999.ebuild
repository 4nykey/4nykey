# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typiconman/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	SRC_URI="
	binary? (
		http://www.ponomar.net/files/PonomarUnicode-1.1.zip
		http://www.ponomar.net/files/FedorovskUnicode-3.0.zip
		http://www.ponomar.net/files/MenaionUnicode-2.0.zip
		http://www.ponomar.net/files/PomorskyUnicode-0.75.zip
	)
	!binary? (
		mirror://githubcl/typiconman/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="Unicode OpenType fonts for Church Slavonic"
HOMEPAGE="http://ponomar.net/cu_support/fonts.html"

LICENSE="|| ( GPL-3 OFL-1.1 )"
SLOT="0"
IUSE="+binary"

DEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		dev-util/grcompiler
	)
"
RDEPEND=""

FONT_SUFFIX="otf ttf"
PATCHES=( "${FILESDIR}"/${PN}_generate.diff )

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		FONT_S="${S}"
	else
		python-any-r1_pkg_setup
		DOCS+=" README.* RUSSIAN"
	fi
	font_pkg_setup
}

src_compile() {
	use binary && return
	local _s="${S}/Indiction/IndictionUnicode.sfd"

	# for consistency
	[[ -f "${_s}" ]] && sed -e '/Layer:/s:TTF:&Layer:' -i "${_s}"

	for _s in */*.sfd; do
		fontforge -script Ponomar/hp-generate.py ${_s} || die
	done

	for _s in */*.gdl; do
		grcompiler "${_s}" "$(dirname ${_s})Unicode.ttf" "${_s%.*}.ttf" || die
		mv -f "${_s%.*}.ttf" "$(dirname ${_s})Unicode.ttf"
	done
}
