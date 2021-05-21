# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	MY_PV="33acc7d"
	[[ -n ${PV%%*_*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="https://adobe-type-tools.github.io/afdko"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.6[${PYTHON_USEDEP}]
	dev-python/fontPens[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.22.1[ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-util/psautohint-2.3[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.60[${PYTHON_USEDEP}]
	>=dev-python/ufoNormalizer-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/ufoProcessor-1.9[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
DOCS=( {README,NEWS}.md docs )
distutils_enable_tests pytest

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-nowheel.diff
	)
	grep -rl '\$(AR) -' c | xargs sed -e 's:\(\$(AR) \)-:\1:' -i
	sed \
		-e 's:==:>=:' \
		-e 's:,<=[0-9.]\+::' \
		-i requirements.txt
	sed -i setup.py \
		-e 's:scripts=\(_get_scripts()\),:data_files=[("bin",\1)],:'

	rm -f docs/*.{yml,plist}
	distutils-r1_python_prepare_all
}

src_compile() {
	tc-export CC CPP AR
	local _d
	find -path '*/linux/gcc/release/Makefile' | while read _d; do
		emake -C "${_d%/Makefile}" \
			XFLAGS="${CFLAGS}" || return
	done
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
	distutils-r1_src_compile
}

python_test() {
	local -x \
		PYTHONPATH="${S}/python:${PYTHONPATH}" \
		PATH="${BUILD_DIR}/test/scripts:${S}/c/build_all:${PATH}"
	distutils_install_for_testing
	pytest -v || die
}
