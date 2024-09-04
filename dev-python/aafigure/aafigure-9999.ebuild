# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="18a2627"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="An ASCII art to image converter"
HOMEPAGE="https://aafigure.readthedocs.io"

LICENSE="BSD"
SLOT="0"
IUSE="test"

DEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
distutils_enable_tests pytest
