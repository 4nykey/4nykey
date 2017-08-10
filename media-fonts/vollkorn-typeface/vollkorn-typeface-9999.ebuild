# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FAlthausen/${PN}.git"
	REQUIRED_USE="binary? ( !font_types_otf )"
else
	inherit vcs-snapshot
	MY_PV="3c1909a"
	MY_PB="${PN%-*}-${PV%_p*}"
	SRC_URI="
	binary? (
		http://${PN}.com/download/${MY_PB/./-}.zip
	)
	!binary? (
		mirror://githubcl/FAlthausen/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
	FONTDIR_BIN=( {PS-O,T}TF )
fi
inherit fontmake

DESCRIPTION="A body typeface with figure sets, ligatures and contextual alternates"
HOMEPAGE="http://vollkorn-typeface.com"

LICENSE="OFL-1.1"
SLOT="0"
DOCS=( Fontlog.txt )

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && use binary && S="${WORKDIR}"
	fontmake_pkg_setup
}
