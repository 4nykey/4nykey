# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EbenSorkin/${PN}.git"
	EGIT_REPO_URI="https://github.com/m4rc1e/${PN}.git"
	EGIT_BRANCH="vf"
else
	inherit vcs-snapshot
	MY_PV="3d7d851"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/EbenSorkin/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/EbenSorkin/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
