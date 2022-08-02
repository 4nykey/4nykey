# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lucy/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="ab7b3cb"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/lucy/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
FONT_SUFFIX="pcf.gz"
FONT_S=( out )
inherit font-r1

DESCRIPTION="A small bitmap font"
HOMEPAGE="https://github.com/lucy/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	x11-apps/bdftopcf
	>dev-lang/python-3
"
