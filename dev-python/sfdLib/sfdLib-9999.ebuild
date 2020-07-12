# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alif-type/${PN}.git"
else
	MY_PV="f874716"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/alif-type/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An SFD to UFO converter"
HOMEPAGE="https://github.com/alif-type/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/ufoLib2[${PYTHON_USEDEP}]
"
