# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ossobuffo/${PN}.git"
	EGIT_REPO_URI="https://github.com/m4rc1e/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b646283"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/ossobuffo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A family of sans-serif fonts in the Eurostile vein"
HOMEPAGE="https://github.com/ossobuffo/${PN}"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
IUSE="interpolate"
