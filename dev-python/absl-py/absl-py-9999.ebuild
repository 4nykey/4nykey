# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
MY_PN="abseil-py"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/abseil/${MY_PN}.git"
else
	MY_PV="06edd9c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="pypi-v${PV}"
	SRC_URI="
		mirror://githubcl/abseil/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="Abseil Python Common Libraries"
HOMEPAGE="https://github.com/abseil/abseil-py"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
