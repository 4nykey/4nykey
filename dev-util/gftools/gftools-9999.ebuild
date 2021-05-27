# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1
MY_PN=tools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
else
	MY_PV="40fbad7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_GL="GlyphsInfo-e33ccf3"
	SRC_URI="
		mirror://githubcl/googlefonts/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/schriftgestalt/${MY_GL%-*}/tar.gz/${MY_GL##*-}
		-> ${MY_GL}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Miscellaneous tools for working with the Google Fonts collection"
HOMEPAGE="https://github.com/googlefonts/${MY_PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/fonttools[${PYTHON_MULTI_USEDEP},ufo(-)]
		dev-python/absl-py[${PYTHON_MULTI_USEDEP}]
		dev-python/protobuf-python[${PYTHON_MULTI_USEDEP}]
		dev-python/PyGithub[${PYTHON_MULTI_USEDEP}]
		dev-python/vttLib[${PYTHON_MULTI_USEDEP}]
		dev-python/statmake[${PYTHON_MULTI_USEDEP}]
		dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
		dev-python/babelfont[${PYTHON_MULTI_USEDEP}]
		dev-python/ttfautohint-py[${PYTHON_MULTI_USEDEP}]
		dev-util/fontmake[${PYTHON_MULTI_USEDEP}]
		app-arch/brotli[python,${PYTHON_MULTI_USEDEP}]
		dev-python/browserstack-local-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pybrowserstack-screenshots[${PYTHON_MULTI_USEDEP}]
		dev-python/glyphsLib[${PYTHON_MULTI_USEDEP}]
		dev-python/ots-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pygit2[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/strictyaml[${PYTHON_MULTI_USEDEP}]
		dev-python/tabulate[${PYTHON_MULTI_USEDEP}]
		dev-python/unidecode[${PYTHON_MULTI_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools_scm[${PYTHON_MULTI_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/tabulate[${PYTHON_MULTI_USEDEP}]
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-setup.diff
	"${FILESDIR}"/${PN}-tests.diff
)
distutils_enable_tests pytest

pkg_pretend() {
	use test && has network-sandbox ${FEATURES} && die \
	"Tests require network access"
}

python_prepare_all() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_GL}/*.xml Lib/${PN}/util/${MY_GL%-*}
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	local -x \
		PYTHONPATH="${BUILD_DIR}/lib:${PYTHONPATH}" \
		PATH="${S}:${PATH}"
	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
