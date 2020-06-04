# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="b4f2232"
	fi
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
	>=dev-python/fonttools-4.6[${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.6.2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/ufoNormalizer[${PYTHON_USEDEP}]
		>=app-text/xmldiff-2.2[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-masters_wcodes.diff
	"${FILESDIR}"/${PN}-setup.diff
	"${FILESDIR}"/${PN}-custom_params.diff
	"${FILESDIR}"/${PN}-skipMissingComponents.diff
)
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_prepare_all() {
	sed -e '/\<wheel\>/d' -i setup.cfg
	distutils-r1_python_prepare_all
}
