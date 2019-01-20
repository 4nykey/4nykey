# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN^}Font"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5a5fff2"
	SRC_URI="
		mirror://githubcl/googlefonts/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A reworking of the classic gothic typeface style"
HOMEPAGE="https://github.com/googlefonts/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
