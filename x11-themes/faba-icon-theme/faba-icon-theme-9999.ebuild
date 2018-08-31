# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 meson
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/snwh/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="6f1cea3"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/snwh/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A sexy and modern icon theme with Tango influences"
HOMEPAGE="https://snwh.org/moka#${PN}"

LICENSE="|| ( LGPL-3+ CC-BY-SA-4.0 )"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
"
