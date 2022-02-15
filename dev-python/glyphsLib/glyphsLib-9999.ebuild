# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	[[ -z ${PV%%*_p*} ]] && MY_PV="b4f2232"
	MY_PV="v${PV/_beta/b}"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A library to provide a bridge from Glyphs source files to UFOs"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0 MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-4.27.1[ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.11.4[${PYTHON_USEDEP}]
	>=dev-python/openstep-plist-0.3[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/ufoNormalizer[${PYTHON_USEDEP}]
		dev-python/ufo2ft[${PYTHON_USEDEP}]
		>=app-text/xmldiff-2.2[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}"/featureNames.diff
)
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_prepare_all() {
	sed -e '/\<wheel\>/d' -i setup.cfg
	distutils-r1_python_prepare_all
}
