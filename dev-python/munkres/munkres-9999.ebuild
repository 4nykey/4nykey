# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bmc/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="df6935b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="release-${PV}"
	SRC_URI="
		mirror://githubcl/bmc/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Module implementing munkres algorithm for the Assignment Problem"
HOMEPAGE="http://software.clapper.org/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
