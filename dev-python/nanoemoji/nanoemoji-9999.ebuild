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
	MY_PV="fbd1a35"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A wee tool to build color fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/absl-py[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.36[ufo(-),${PYTHON_USEDEP}]
	dev-python/picosvg[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/ufo2ft[${PYTHON_USEDEP}]
	dev-python/py-zopfli[${PYTHON_USEDEP}]
	dev-python/ninja-python-distributions[${PYTHON_USEDEP}]
	media-gfx/pngquant
	media-libs/resvg
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/setup.diff
	"${FILESDIR}"/a205dfd.patch
)
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
