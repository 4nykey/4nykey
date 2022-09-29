# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="79d41e6"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A python package for maintaining the Noto Fonts project"
HOMEPAGE="https://github.com/googlefonts/nototools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-util/afdko-3.9.1[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
	>=dev-python/attrs-21.4[${PYTHON_USEDEP}]
	>=dev-python/black-22.6[${PYTHON_USEDEP}]
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=app-arch/brotli-1.0.9[python,${PYTHON_USEDEP}]
	>=dev-python/click-8.1.3[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.9.2[${PYTHON_USEDEP}]
	>=dev-python/fontParts-0.10.7[${PYTHON_USEDEP}]
	>=dev-python/fontPens-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.34.4[ufo(-),${PYTHON_USEDEP}]
	>=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.9[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.2[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
	>=dev-python/regex-2022.7.25[${PYTHON_USEDEP}]
	>=media-gfx/scour-0.38.2[${PYTHON_USEDEP}]
	>=dev-python/toml-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/typed-ast-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/ufoNormalizer-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/ufoProcessor-1.9[${PYTHON_USEDEP}]
	>=dev-python/py-zopfli-0.2.1[${PYTHON_USEDEP}]
	dev-python/unicodedata2[${PYTHON_USEDEP}]
	dev-python/freetype-py[${PYTHON_USEDEP}]
	media-libs/harfbuzz
"
RDEPEND="
	${DEPEND}
	>=app-i18n/unicode-cldr-37
	>=app-i18n/unicode-data-15
	>=app-i18n/unicode-emoji-15
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
