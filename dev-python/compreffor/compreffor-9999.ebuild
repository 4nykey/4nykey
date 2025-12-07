# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_IN_SOURCE_BUILD=1
DISTUTILS_EXT=1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="639877c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit distutils-r1

DESCRIPTION="A CFF table subroutinizer for FontTools"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cython test"

RDEPEND="
	>=dev-python/fonttools-4.54.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}"/${PN}-test.diff )
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_prepare_all() {
	sed -e 's:, "setuptools_git_ls_files"::' -i setup.py
	distutils-r1_python_prepare_all
}

python_prepare() {
	sed -e \
		"s:@_INSTDIR_@:${BUILD_DIR}/install$(python_get_sitedir)/${PN}:" \
		-i setup.cfg
}
