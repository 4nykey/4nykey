# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/source-foundry/${PN}.git"
else
	MY_PV="e66b6a2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/source-foundry/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri test"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Font version string reporting and modification library"
HOMEPAGE="https://github.com/source-foundry/${PN}"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/fonttools-4.28.1[${PYTHON_USEDEP}]
	>=dev-python/GitPython-3.1.24[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest
