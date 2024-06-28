# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FONT_SUFFIX=otf
FONT_S=( static/OTF )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alerque/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="983ab6c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		!binary? (
			mirror://githubcl/alerque/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
		binary? (
			https://github.com/alerque/${PN}/releases/download/v${PV%_p*}/${PN^}-${PV%_p*}.tar.xz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN^}-${PV%_p*}"
fi
inherit font-r1

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alerque/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"
