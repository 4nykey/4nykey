# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="NunitoSans"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
else
	MY_PV="19beed7"
	SRC_URI="
		mirror://githubcl/alexeiva/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A well balanced sans serif typeface superfamily"
HOMEPAGE="https://github.com/googlefonts/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
