# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
MY_PN="Inconsolata-LGC"
myemakeargs=(
	SRCDIR=.
	INTERPOLATE=
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/glebd/${MY_PN}.git"
	EGIT_BRANCH="tight"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="LGC-${PV}"
	SRC_URI="
	binary? (
		font_types_otf? (
			https://github.com/MihailJP/${MY_PN}/releases/download/${MY_PV}/${MY_PN/-}-OT-${PV}.tar.xz
		)
		font_types_ttf? (
			https://github.com/MihailJP/${MY_PN}/releases/download/${MY_PV}/${MY_PN/-}-${PV}.tar.xz
		)
	)
	!binary? (
		mirror://githubcl/MihailJP/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A version of Inconsolata with Greek and Cyrillic support"
HOMEPAGE="https://github.com/MihailJP/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
