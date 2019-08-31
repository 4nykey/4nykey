# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/unified-font-object/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="1ed0111"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/unified-font-object/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tool that will normalize the XML and other data inside of a UFO"
HOMEPAGE="https://github.com/unified-font-object/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
"
RDEPEND="
	${DEPEND}
"

python_test() {
	esetup.py test
}
