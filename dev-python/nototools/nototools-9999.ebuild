# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="d8f3d16"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV//./-}-tooling-for-phase3-update"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A python package for maintaining the Noto Fonts project"
HOMEPAGE="https://github.com/googlei18n/nototools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.9.1[${PYTHON_USEDEP}]
	>=dev-python/pillow-4[${PYTHON_USEDEP}]
	dev-python/pyclipper[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
	dev-python/freetype-py[${PYTHON_USEDEP}]
	media-libs/harfbuzz
"
DEPEND="
	${RDEPEND}
"

python_prepare_all() {
	sed -e "s:HB_SHAPE_PATH,:'/usr/bin/hb-shape',:" \
		-i "${S}"/nototools/render.py
	distutils-r1_python_prepare_all
}

python_test() {
	cd tests
	./run_tests || die
}
