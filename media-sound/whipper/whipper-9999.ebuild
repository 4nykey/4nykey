# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1

inherit toolchain-funcs distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whipper-team/${PN}.git"
else
	MY_PV="a4b9742"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/whipper-team/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A Python CD-DA ripper preferring accuracy over speed"
HOMEPAGE="https://github.com/whipper-team/${PN}"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	|| (
		dev-libs/libcdio-paranoia
		media-sound/cdparanoia
	)
	app-eselect/eselect-cdparanoia
	app-cdr/cdrdao
	dev-python/musicbrainzngs[${PYTHON_USEDEP}]
	media-libs/mutagen[${PYTHON_USEDEP}]
	dev-python/pycdio[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	media-libs/libsndfile
	media-sound/sox
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/twisted[${PYTHON_USEDEP}] )
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"
DOCS=( {CHANGELOG,README}.md HACKING TODO )
distutils_enable_tests pytest

src_prepare() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	sed \
		-e 's:cd-paranoia:cdparanoia:' \
		-i whipper/program/cdparanoia.py
	has network-sandbox ${FEATURES} && sed \
		-e '/^class TestAccurateRipResponse(TestCase)/,/^# XXX: test arc.py/d' \
		-i whipper/test/test_common_accurip.py
	default
}
