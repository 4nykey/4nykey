# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hchargois/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="cc36b8c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/hchargois/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
FONT_SUFFIX="pcf.gz"
FONT_S=( . hidpi )
inherit font-ebdftopcf font-r1

DESCRIPTION="A monospace bitmap font"
HOMEPAGE="http://font.gohu.org"

LICENSE="WTFPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

src_compile() {
	font-ebdftopcf_src_compile
}
