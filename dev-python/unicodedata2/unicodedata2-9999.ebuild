# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	MY_PV="$(ver_rs 3 -)"
	[[ -z ${PV%%*_p*} ]] && MY_PV="45378d5"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Unicodedata backport, updates"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest
