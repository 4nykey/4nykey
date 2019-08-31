# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1 eapi7-ver
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5c4e5ae"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 3 '.post')"
	MY_SK="skia-98900b5"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/fonttools/${MY_SK%-*}/tar.gz/${MY_SK##*-}
		-> ${MY_SK}.tar.gz
	"
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
"
DEPEND="
	${RDEPEND}
	>=dev-python/cython-0.28.4[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
}

python_prepare_all() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_SK}/* "${S}"/src/cpp/skia
	fi
	sed -e '/doctest-cython/d' -i tox.ini
	distutils-r1_python_prepare_all
}

python_test() {
	pytest -v || die "Tests failed with ${EPYTHON}"
}
