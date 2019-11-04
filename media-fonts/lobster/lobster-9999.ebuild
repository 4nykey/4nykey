# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="The-${PN^}-Font"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${MY_PN}"
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}"
else
	inherit vcs-snapshot
	MY_PV="2cb4569"
	SRC_URI="
		mirror://githubcl/impallari/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A bold condensed script font with ligatures and alternates"
HOMEPAGE="http://www.impallari.com/lobster"

LICENSE="OFL-1.1"
SLOT="0"
