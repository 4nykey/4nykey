# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	MY_PV="${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="${PV/_p/.post}"
	SETUPTOOLS_SCM_PRETEND_VERSION="${MY_PV}"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A Cython wrapper for the Clipper library"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${MY_PV}"
}
