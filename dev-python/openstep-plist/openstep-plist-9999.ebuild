# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	MY_PV="f950375"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="OpenStep plist parser and writer written in Cython"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && \
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
}
