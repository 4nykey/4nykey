# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eugmes/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="dfb5c3f"
	[[ -n ${PV%%*_p*} ]] && MY_PV="release/${PV}"
	SRC_URI="mirror://githubcl/eugmes/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A program for making font samples that show Unicode coverage of the font"
HOMEPAGE="https://sourceforge.net/projects/${PN}"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype:2
	x11-libs/cairo
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	app-i18n/unicode-data
"

src_configure() {
	local mycmakeargs=(
		-DUNICODE_BLOCKS=/usr/share/unicode-data/Blocks.txt
	)
	cmake-utils_src_configure
}
