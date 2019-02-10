# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="ab51531"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="http://www.adobe.com/devnet/opentype/afdko.html"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/cu2qu[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
	dev-python/fontPens[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.37[ufo,unicode,${PYTHON_USEDEP}]
	dev-python/MutatorMath[${PYTHON_USEDEP}]
	dev-util/psautohint[${PYTHON_USEDEP}]
	dev-python/ufoProcessor[${PYTHON_USEDEP}]
	dev-python/ufoNormalizer[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		python_targets_python2_7? (
			dev-python/subprocess32[python_targets_python2_7]
		)
	)
"
DOCS=( {README,NEWS}.md html pdf )

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-nowheel.diff
	)
	grep -rl '\$(AR) -' c | xargs sed -e 's:\(\$(AR) \)-:\1:' -i
	grep -rl 'import subprocess32' tests | xargs sed -i -e \
	's%import subprocess32%import sys\nif int(sys.version[0])>2:\
	import subprocess\nelse:\n\t&%'
	sed -e 's:==:>=:' -i requirements.txt
	sed -i setup.py \
		-e 's:scripts=\(_get_scripts()\),:data_files=[("bin",\1)],:'

	mkdir html pdf
	mv -f docs/*.html html
	mv -f docs/*.pdf pdf

	distutils-r1_python_prepare_all
}

src_compile() {
	tc-export CC CPP AR
	local _d
	find -path '*/linux/gcc/release/Makefile' | while read _d; do
		emake -C "${_d%/Makefile}" \
			XFLAGS="${CFLAGS}" || return
	done
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_p*}"
	distutils-r1_src_compile
}

python_test() {
	local -x \
	PYTHONPATH="${BUILD_DIR}/test/lib/python:${PYTHONPATH}" \
	PATH="${BUILD_DIR}/test/scripts:${S}/c/build_all:${PATH}"
	mkdir -p "${BUILD_DIR}/test/lib/python"
	distutils_install_for_testing
	pytest -v || die
}
