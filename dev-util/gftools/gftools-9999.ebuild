# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
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
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Miscellaneous tools for working with the Google Fonts collection"
HOMEPAGE="https://github.com/googlefonts/${MY_PN}"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/fonttools[${PYTHON_USEDEP},ufo(-)]
		dev-python/axisregistry[${PYTHON_USEDEP}]
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/glyphsLib[${PYTHON_USEDEP}]
		dev-python/gflanguages[${PYTHON_USEDEP}]
		dev-python/glyphsets[${PYTHON_USEDEP}]
		dev-python/PyGithub[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/ots-python[${PYTHON_USEDEP}]
		dev-python/vttLib[${PYTHON_USEDEP}]
		dev-python/pygit2[${PYTHON_USEDEP}]
		dev-python/strictyaml[${PYTHON_USEDEP}]
		dev-util/fontmake[json,${PYTHON_USEDEP}]
		dev-python/statmake[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/babelfont[${PYTHON_USEDEP}]
		dev-python/ttfautohint-py[${PYTHON_USEDEP}]
		app-arch/brotli[python,${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/hyperglot[${PYTHON_USEDEP}]
		dev-python/fontFeatures[${PYTHON_USEDEP}]
		dev-python/vharfbuzz[${PYTHON_USEDEP}]
		dev-python/nanoemoji[${PYTHON_USEDEP}]
		dev-python/font-v[${PYTHON_USEDEP}]
		dev-util/afdko[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/nam-files[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/tabulate[${PYTHON_USEDEP}]
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
"
PATCHES=( "${FILESDIR}"/setup.diff )
EPYTEST_DESELECT=(
	tests/push/test_servers.py
	tests/test_gfgithub.py
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
	sed -e '/"gftools-build-font2ttf",/d' -i bin/test_args.py
	distutils-r1_python_prepare_all
}

python_test() {
	epytest "${S}"/tests
}
