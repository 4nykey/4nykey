# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cmck/${PN}.git"
else
	MY_PV="${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="598358f"
	SRC_URI="
		mirror://githubcl/cmck/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A python api wrapper and client for Browserstack Screenshots API"
HOMEPAGE="https://github.com/cmck/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
