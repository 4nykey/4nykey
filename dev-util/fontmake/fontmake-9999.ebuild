# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="1ef915d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A wrapper for several Python libraries to compile fonts from sources"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.9.2[${PYTHON_USEDEP}]
	dev-python/cu2qu[${PYTHON_USEDEP}]
	dev-python/glyphsLib[${PYTHON_USEDEP}]
	dev-python/ufo2ft[${PYTHON_USEDEP}]
	dev-python/MutatorMath[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	media-gfx/ttfautohint
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		media-gfx/fontdiff
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-mti_paths.diff
)

src_prepare() {
	default
	has test $FEATURES || return
	sed \
		-e 's:fontmake:${EPYTHON} -m &:g' \
		-e 's:\./fontdiff:fontdiff:g' \
		-e 's%check_failure "%[[ $? -eq 0 ]] || die "Tests failed under ${EPYTHON}: %g' \
		-i "${S}"/test/run.sh
}

python_test() {
	cd "${S}"/test
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" . ./run.sh
}
