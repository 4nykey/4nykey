# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
MY_PN="lang"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="26f1b69"
		SRC_URI="
			mirror://githubcl/googlefonts/${MY_PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		"
		S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
	else
		inherit pypi
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A Python API to evaluate language support in the Google Fonts collection"
HOMEPAGE="https://github.com/googlefonts/${MY_PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/protobuf[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-libs/protobuf[protoc(+)]
	test? (
		dev-python/uharfbuzz[${PYTHON_USEDEP}]
		dev-python/youseedee[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

pkg_pretend() {
	use test && has network-sandbox ${FEATURES} && die \
	"Tests require network access"
}

python_prepare_all() {
	[[ -z ${PV%%*_p*} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	protoc -I ./Lib/gflanguages --python_out=./Lib/gflanguages \
		./Lib/gflanguages/languages_public.proto
	distutils-r1_python_prepare_all
}
