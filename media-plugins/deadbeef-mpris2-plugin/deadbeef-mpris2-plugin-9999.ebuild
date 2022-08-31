# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/DeaDBeeF-Player/${PN}.git"
	inherit git-r3
else
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="056fe76"
	SRC_URI="
		mirror://githubcl/DeaDBeeF-Player/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit autotools

DESCRIPTION="A plugin that implements the MPRISv2 for DeaDBeeF"
HOMEPAGE="https://github.com/DeaDBeeF-Player/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	>=media-sound/deadbeef-1.9.1-r1
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
