# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rougier/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="04c62af"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/rougier/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python bindings for the freetype library"
HOMEPAGE="https://github.com/rougier/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/freetype:2
"
DEPEND="
	${RDEPEND}
"
