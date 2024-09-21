# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	[[ -z ${PV%%*_p*} ]] && MY_PV="b4f2232"
	MY_PV="v${PV/_beta/b}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A library to provide a bridge from Glyphs source files to UFOs"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0 MIT"
SLOT="0"

RDEPEND="
	>=dev-python/fonttools-4.53.1[ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.16[${PYTHON_USEDEP}]
	>=dev-python/openstep-plist-0.3.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/ufoNormalizer-0.6.1[${PYTHON_USEDEP}]
		>=dev-python/ufo2ft-3.0.0_beta1[${PYTHON_USEDEP}]
		>=app-text/xmldiff-2.6.3[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}"/custom_params.diff
)
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
