# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=scikit-build-core
inherit cmake distutils-r1
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
RESTRICT+=" test"

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

src_prepare() {
	eapply "${FILESDIR}"/ninja.diff
	cmake_src_prepare
	distutils-r1_src_prepare
}

src_configure() {
	DISTUTILS_ARGS=(
		-Dninja_SOURCE_DIR="${WORKDIR}/${MY_NI}"
	)
}
