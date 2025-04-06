# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="94bfe02"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Test two sets of fonts for visual regressions on different browsers"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pybrowserstack-screenshots[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest

pkg_pretend() {
	use test && has network-sandbox ${FEATURES} && die \
	"Tests require network access"
}
