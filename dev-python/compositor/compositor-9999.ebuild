# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robotools/${PN}.git"
else
	MY_PV="9265bc8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/robotools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A basic OpenType GSUB and GPOS layout engine"
HOMEPAGE="https://github.com/robotools/${PN}"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
