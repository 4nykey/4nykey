# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/Serranya/${PN}.git"
	inherit git-r3
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="91e20e6"
		inherit vcs-snapshot
	fi
	SRC_URI="
		mirror://githubcl/Serranya/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools

DESCRIPTION="A plugin that implements the MPRISv2 for DeaDBeeF"
HOMEPAGE="https://github.com/Serranya/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	media-sound/deadbeef
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
