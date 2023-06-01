# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1
MY_PN="${PN}.py"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MFEK/${MY_PN}.git"
else
	MY_PV="f874716"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/MFEK/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi

DESCRIPTION="An SFD to UFO converter"
HOMEPAGE="https://github.com/MFEK/${MY_PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/ufoLib2[${PYTHON_USEDEP}]
"
