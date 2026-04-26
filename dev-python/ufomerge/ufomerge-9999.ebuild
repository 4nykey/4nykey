# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="9a4cc5c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A utility to merge together two UFO source format fonts into a single file"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/black[${PYTHON_USEDEP}]
		dev-python/fontFeatures[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

python_prepare_all() {
	if [[ -n ${PV%%*9999} ]]; then
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
	fi
	distutils-r1_python_prepare_all
}
