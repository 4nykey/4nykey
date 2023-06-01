# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="948cf99"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	RESTRICT="primaryuri"
fi
inherit fontmake

DESCRIPTION="Update of Vernon Adam's Amatic SC and Hafontia's Amatica SC"
HOMEPAGE="https://github.com/googlefonts/AmaticSC"

LICENSE="OFL-1.1"
SLOT="0"
PATCHES=( "${FILESDIR}"/${PN}_hatafpatah-hb.diff )
