# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LucasFonts/${PN}.git"
else
	MY_PV="36a6973"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/LucasFonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit distutils-r1

DESCRIPTION="Converter and deserializer for FontLab Studio 5 VFB files"
HOMEPAGE="https://github.com/LucasFonts/vfbLib"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.61[ufo(-),${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/ufoLib2[${PYTHON_USEDEP}]
	dev-python/ufoNormalizer[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
