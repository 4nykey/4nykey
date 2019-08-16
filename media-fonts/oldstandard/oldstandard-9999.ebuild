# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%*ard}"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/akryukov/${MY_PN}.git"
	EGIT_REPO_URI="https://github.com/alexeiva/${MY_PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="3353f30"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/akryukov/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A font with wide range of Latin, Greek and Cyrillic characters"
HOMEPAGE="https://github.com/akryukov/oldstand"

LICENSE="OFL-1.1"
SLOT="0"
