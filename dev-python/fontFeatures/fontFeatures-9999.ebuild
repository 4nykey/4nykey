# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${PN}.git"
else
	MY_PV="1d44333"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/simoncozens/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Python library for manipulating OpenType font features"
HOMEPAGE="https://github.com/simoncozens/${PN}"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/glyphtools[${PYTHON_USEDEP}]
	dev-python/fonttools[ufo(-),${PYTHON_USEDEP}]
	dev-python/beziers[${PYTHON_USEDEP}]
	dev-python/youseedee[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/babelfont[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}"/babelfont-305.diff )
distutils_enable_tests pytest

pkg_pretend() {
	use test && has network-sandbox ${FEATURES} && die \
	"Tests require network access"
}
