# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/huertatipografica/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="988427b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_/-}"
	SRC_URI="
		mirror://githubcl/huertatipografica/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A humanist sans-serif family with a calligraphic feeling"
HOMEPAGE="https://github.com/huertatipografica/${PN}"

LICENSE="OFL-1.1"
SLOT="0"

DOCS="*.txt"
