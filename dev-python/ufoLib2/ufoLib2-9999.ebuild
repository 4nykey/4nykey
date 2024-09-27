# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
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
	KEYWORDS="~amd64"
fi

DESCRIPTION="A UFO font library"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="msgpack orjson test"
REQUIRED_USE="test? ( msgpack orjson )"

RDEPEND="
	>=dev-python/fonttools-4.29.1[ufo(-),${PYTHON_USEDEP}]
	>=dev-python/attrs-22.1[${PYTHON_USEDEP}]
	>=dev-python/cattrs-22.2[${PYTHON_USEDEP}]
	msgpack? ( >=dev-python/msgpack-1.0.4[${PYTHON_USEDEP}] )
	orjson? ( dev-python/orjson[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/orjson[${PYTHON_USEDEP}] )
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && \
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
}
