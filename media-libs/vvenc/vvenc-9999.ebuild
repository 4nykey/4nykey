# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/fraunhoferhhi/${PN}.git"
	inherit git-r3
	SLOT="0/${PV}"
else
	MY_PV="c305325"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/fraunhoferhhi/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
	SLOT="0/$(ver_cut 1-2)"
fi

DESCRIPTION="Fraunhofer Versatile Video (H.266/VVC) Encoder"
HOMEPAGE="https://www.hhi.fraunhofer.de/en/departments/vca/technologies-and-solutions/h266-vvc.html"

LICENSE="BSD"

IUSE="test"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"
