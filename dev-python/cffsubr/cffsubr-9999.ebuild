# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	MY_PV="a45f94c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Standalone CFF subroutinizer based on AFDKO tx tool"
HOMEPAGE="https://github.com/adobe-type-tools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-util/afdko-3.6.1[${PYTHON_USEDEP}]
"
PATCHES=( "${FILESDIR}"/${PN}-system_tx.diff )
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_prepare_all() {
	sed -e '/\(setuptools-git-ls-files\|ext_modules=\)/d' -i setup.py
	distutils-r1_python_prepare_all
}
