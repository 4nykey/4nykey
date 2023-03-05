# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="c899bcf"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A tool to simplify SVGs"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/skia-pathops[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
