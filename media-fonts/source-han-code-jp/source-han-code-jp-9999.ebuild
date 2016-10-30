# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	inherit vcs-snapshot
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}R
			-> ${P}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="An monospaced font for mixed Latin and Japanese text"
HOMEPAGE="http://adobe-fonts.github.io/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? ( dev-util/afdko )
"

FONT_SUFFIX="otf"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	else
		S="${WORKDIR}/${P}$(usex binary 'R' '')"
	fi
	if use binary; then
		FONT_S=( OTF )
	else
		FONT_S=( Bold ExtraLight Heavy Light Medium Normal Regular )
		. /etc/afdko
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	/bin/sh "${S}"/commands.sh
}
