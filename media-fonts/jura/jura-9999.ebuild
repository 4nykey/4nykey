# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ossobuffo/${PN}.git"
else
	MY_PV="c2eda90"
	SRC_URI="
		mirror://githubcl/ossobuffo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A family of sans-serif fonts in the Eurostile vein"
HOMEPAGE="https://github.com/ossobuffo/${PN}"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( !font_types_otf )
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
