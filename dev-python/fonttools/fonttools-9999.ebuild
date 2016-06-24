# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/behdad/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="78c29bc"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/behdad/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="https://github.com/behdad/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""
DOCS=( README.md NEWS )

DEPEND="
	>=dev-python/numpy-1.0.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
