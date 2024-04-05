# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
MY_NI="ninja-1.11.1"
SRC_URI="
	mirror://githubcl/ninja-build/ninja/tar.gz/v${MY_NI#*-} -> ${MY_NI}.tar.gz
"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-build/${PN}.git"
else
	SRC_URI+="
		mirror://githubcl/scikit-build/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A tool to build Ninja Python wheels"
HOMEPAGE="https://github.com/scikit-build/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-build/ninja
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/path[${PYTHON_USEDEP}] )
"
distutils_enable_tests pytest

src_unpack() {
	default
	[[ -z ${PV%%*9999} ]] && git-r3_src_unpack
}

python_prepare_all() {
	sed \
		-e '/import setup/ s:skbuild:setuptools:' \
		-e '/entry_points={/,/},/d' \
		-i setup.py
	sed \
		-e "/^DATA = os.path.join/ s:=.*:= '${EPREFIX}/usr':" \
		-i src/ninja/__init__.py
	cp ../${MY_NI}/misc/ninja_syntax.py src/ninja
	sed -e '/addopts = /d' -i setup.cfg
	distutils-r1_python_prepare_all
}
