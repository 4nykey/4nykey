# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 flag-o-matic
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="815070e"
	MY_SB="skia-builder-501d7a3"
	MY_SK="skia-a777ad7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 3 '.post')"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
		mirror://githubcl/fonttools/${MY_SB%-*}/tar.gz/${MY_SB##*-}
		-> ${MY_SB}.tar.gz
		mirror://githubcl/fonttools/${MY_SK%-*}/tar.gz/${MY_SK##*-}
		-> ${MY_SK}.tar.gz
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
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-python/cython-3.2[${PYTHON_USEDEP}]
	dev-build/gn
"
distutils_enable_tests pytest

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
	rm -rf src/cpp/skia-builder ../${MY_SB}/skia
	cp -frl ../${MY_SB} src/cpp/skia-builder
	cp -frl ../${MY_SK} src/cpp/skia-builder/skia
	sed -e '/doctest-cython/d' -i tox.ini
	sed \
		-e "s:build_skia_py, :&'--no-virtualenv', '--no-sync-deps', '--no-fetch-gn', '--gn-path', '${EPREFIX}/usr/bin/gn', :" \
		-i setup.py
	sed \
		-e '/subprocess.check_call(\["ninja"/s:"ninja",:& "-v",:' \
		-i src/cpp/skia-builder/build_skia.py
	sed \
		-e "s:\"-O3\":$(printf '"%s", ' ${CXXFLAGS}):" \
		-i src/cpp/skia-builder/skia/gn/skia/BUILD.gn
	distutils-r1_python_prepare_all
}
