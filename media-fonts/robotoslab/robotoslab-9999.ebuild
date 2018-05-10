# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_SRCDIR=build
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
	EGIT_BRANCH="mastering"
else
	inherit vcs-snapshot
	MY_PV="bfd066e"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="Roboto Slab typeface"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="!binary"

src_prepare() {
	local PATCHES=( "${FILESDIR}"/${PN}_typo.diff ) \
		_b=${FONT_SRCDIR}/${PN}
	fontmake_src_prepare
	mkdir -p ${_b}
	ln -s "${S}"/sources ${_b}/master_ufo
	ln -s "${S}"/sources ${FONT_SRCDIR}/instance_ufo
}
