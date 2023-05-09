# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alerque/${PN}.git"
else
	MY_PV="1de06db"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/alerque/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Discard GUI information from SFD files"
HOMEPAGE="https://github.com/alerque/${PN}"

LICENSE="CC0-1.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/sfdutf7[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
