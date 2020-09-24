# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LettError/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="6bd7ac7"
	fi
	SRC_URI="
		mirror://githubcl/LettError/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Python package for processing and generating UFO files"
HOMEPAGE="https://github.com/LettError/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.32[ufo(-),${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
	dev-python/fontParts[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_test() {
	"${EPYTHON}" Tests/tests.py || die "Tests failed with ${EPYTHON}"
}
