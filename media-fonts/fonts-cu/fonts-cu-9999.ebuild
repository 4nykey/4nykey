# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES="otf ttf"
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
		mirror://githubcl/typiconman/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Unicode OpenType fonts for Church Slavonic"
HOMEPAGE="http://ponomar.net/cu_support/fonts.html"

LICENSE="|| ( GPL-3 OFL-1.1 )"
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
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		font_types_ttf? ( dev-util/grcompiler )
	)
"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done

	if use binary; then
		S="${WORKDIR}"
	else
		python-any-r1_pkg_setup
		PATCHES=( "${FILESDIR}"/${PN}_generate.diff )
	fi

	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	local _s

	# for consistency
	sed -e '/Layer:/s:\<TTF\>:&Layer:' -i "${S}"/*/*.sfd

	for _s in */*.sfd; do
		fontforge -script Ponomar/hp-generate.py ${_s} || die
	done

	use font_types_ttf || return
	for _s in */*.gdl; do
		grcompiler "${_s}" "$(dirname ${_s})Unicode.ttf" "${_s%.*}.ttf" || die
		mv -f "${_s%.*}.ttf" "$(dirname ${_s})Unicode.ttf"
	done
}
