# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="6d6b18b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A Python wrapper for ttfautohint"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	media-gfx/ttfautohint
"
DEPEND="
	test? (
		dev-python/fonttools[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

src_prepare() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	sed -e '/ext_modules=/d' -i setup.py
	default
}
