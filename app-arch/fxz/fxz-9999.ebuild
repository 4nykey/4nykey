# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/conor42/${PN}.git"
else
	MY_PV="f12d7eb"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/conor42/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A fork of XZ Utils with multi-threaded radix match finder and optimized encoder"
HOMEPAGE="https://github.com/conor42/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e '/COPYING/d' -i Makefile.am
	eautoreconf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete
}
