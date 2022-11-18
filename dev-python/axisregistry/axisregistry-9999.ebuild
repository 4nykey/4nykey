# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="1622ce9"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A Python API to access data from the Google Fonts variable fonts Axis Registry"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	sed -e '/setuptools_scm/ s:,<6.1::' -i setup.py
	distutils-r1_python_prepare_all
}
