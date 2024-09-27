# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 flag-o-matic
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="815070e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 3 '.post')"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
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
	media-libs/skia:0/113
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
	export BUILD_SKIA_FROM_SOURCE=0
	append-cppflags "-I${EROOT}/usr/include/skia"
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e '/doctest-cython/d' -i tox.ini
	sed -e '/-std=c++14/d' -i setup.py
	grep -rl '"include/' src/python/pathops | xargs sed 's:"include/:"skia/:' -i
}
