# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="5c4e5ae"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 3 '.post')"
	MY_SK="skia-3517aa7"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/fonttools/${MY_SK%-*}/tar.gz/${MY_SK##*-}
		-> ${MY_SK}.tar.gz
	"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python bindings for the Skia Path Ops"
HOMEPAGE="
https://github.com/fonttools/${PN}
https://skia.org/dev/present/pathops
"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=media-libs/skia-80:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-python/cython-0.28.4[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	export BUILD_SKIA_FROM_SOURCE=0
}

python_prepare_all() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_SK}/* "${S}"/src/cpp/skia
	fi
	sed -e '/doctest-cython/d' -i tox.ini
	distutils-r1_python_prepare_all
}
