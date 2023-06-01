# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ossobuffo/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="8f55b34"
	SRC_URI="
		mirror://githubcl/ossobuffo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi
inherit fontmake

DESCRIPTION="A sans-serif typeface similar to the one often used in elementary classrooms"
HOMEPAGE="https://github.com/ossobuffo/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
