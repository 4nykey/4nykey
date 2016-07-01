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
		!afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}R
			-> ${P}R.tar.gz
		)
		afdko? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="An monospaced font for mixed Latin and Japanese text"
HOMEPAGE="http://adobe-fonts.github.io/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="afdko"

DEPEND="
	afdko? ( dev-util/afdko )
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="README.md relnotes.txt"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex afdko master release)"
	else
		S="${WORKDIR}/${P}$(usex afdko '' 'R')"
		FONT_S="${S}"
	fi
	font_pkg_setup
}

src_compile() {
	if use afdko; then
		source ${EROOT}etc/afdko
		/bin/sh "${S}"/commands.sh
	fi
	find "${S}" -mindepth 2 -name "*.${FONT_SUFFIX}" -exec mv -f {} "${S}" \;
}
