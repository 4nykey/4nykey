# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="e685526"
	fi
	MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A UFO font library"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-4.11[ufo(-),${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && \
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-newGlyph.diff
	)
	sed -e '/\<wheel\>/d' -i setup.cfg
	distutils-r1_python_prepare_all
}
