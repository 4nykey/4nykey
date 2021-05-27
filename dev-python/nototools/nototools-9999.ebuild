# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="39ff50d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A python package for maintaining the Noto Fonts project"
HOMEPAGE="https://github.com/googlefonts/nototools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-util/afdko-3.4[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.3[${PYTHON_USEDEP}]
	>=dev-python/black-19.10_beta0[${PYTHON_USEDEP}]
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=app-arch/brotli-1.0.7[python,${PYTHON_USEDEP}]
	>=dev-python/click-7.1.2[${PYTHON_USEDEP}]
	>=dev-python/cu2qu-1.6.7[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.6[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.6[${PYTHON_USEDEP}]
	>=dev-python/fontParts-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.11[ufo(-),${PYTHON_USEDEP}]
	>=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.8[${PYTHON_USEDEP}]
	>=dev-python/pillow-7.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.1.0_p1[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
	>=dev-python/regex-2020.4[${PYTHON_USEDEP}]
	>=media-gfx/scour-0.37[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/ufoNormalizer-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/ufoProcessor-1.9[${PYTHON_USEDEP}]
	>=dev-python/py-zopfli-0.1.7[${PYTHON_USEDEP}]
	dev-python/unicodedata2[${PYTHON_USEDEP}]
	dev-python/freetype-py[${PYTHON_USEDEP}]
	media-libs/harfbuzz
"
RDEPEND="
	${DEPEND}
	>=app-i18n/unicode-cldr-37
	>=app-i18n/unicode-data-13
	>=app-i18n/unicode-emoji-13.1
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed \
		-e '/packages=/s: + \["third_party"\]::' \
		-i setup.py
	sed \
		-e "/third_party.*\<ucd\>/s:path.abspath.*:'${EROOT}/usr/share/unicode-data':" \
		-e 's:"\(emoji-[a-z-]\+\.txt"\):"../unicode/emoji/\1:g' \
		-i nototools/unicode_data.py
	grep -rl CLDR_DIR nototools | xargs sed -i \
		-e "/CLDR_DIR =/s:=.*:= '${EROOT}/usr/share/unicode/cldr':"
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_test() {
	cd tests
	# ./run_tests
	local _t
	for _t in *_test.py; do
		echo "Running ${_t}"
		${EPYTHON} "${_t}" || die "${_t} failed with ${EPYTHON}"
	done
}
