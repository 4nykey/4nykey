# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wbond/${PN}.git"
else
	MY_PV="c91c864"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/wbond/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

RESTRICT+=" test"
DESCRIPTION="Python crypto library backed by the OS"
HOMEPAGE="https://github.com/wbond/${PN}"

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-python/asn1crypto[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
distutils_enable_tests pytest
