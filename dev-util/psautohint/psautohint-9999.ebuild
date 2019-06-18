# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
DISTUTILS_IN_SOURCE_BUILD=1
EMESON_SOURCE="${S}/libpsautohint"
inherit meson distutils-r1

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="427ab23"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_beta/b}"
	MY_PV="${MY_PV/_rc/c}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A standalone version of AFDKO autohinter"
HOMEPAGE="https://github.com/adobe-type-tools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/fonttools-3.41[ufo,${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_p*}"
	MESON_BUILD_DIR="${WORKDIR}/${P}-build"
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-bininpath.diff
	)
	distutils-r1_python_prepare_all
}

src_configure() {
	BUILD_DIR="${MESON_BUILD_DIR}" \
		meson_src_configure
	distutils-r1_src_configure
}

src_compile() {
	BUILD_DIR="${MESON_BUILD_DIR}" \
		meson_src_compile
	distutils-r1_src_compile
}

python_compile() {
	esetup.py build_py build_ext \
		--library-dirs "${MESON_BUILD_DIR}"
}

src_install() {
	BUILD_DIR="${MESON_BUILD_DIR}" \
		meson_src_install
	distutils-r1_src_install
}

python_install() {
	distutils-r1_python_install --skip-build
}
