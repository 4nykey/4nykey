# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/etunni/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="7167ba2"
	SRC_URI="
		mirror://githubcl/etunni/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A serif typeface with soft shapes and terminal forms shaped like curls"
HOMEPAGE="https://github.com/etunni/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
