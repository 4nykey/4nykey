# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/be5invis/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	SRC_URI="
	binary? (
		https://github.com/be5invis/${PN^}/releases/download/v${PV}/${PN}-pack-${PV}.7z
	)
	!binary? (
		mirror://githubcl/be5invis/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	DEPEND="binary? ( app-arch/p7zip )"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Spatial efficient monospace font family for programming"
HOMEPAGE="https://be5invis.github.io/Iosevka"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND+="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		>=net-libs/nodejs-6.0[npm]
		media-gfx/ttfautohint
		dev-util/otfcc
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
	else
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	npm install
	emake fw fonts-hooky fonts-hooky-term fonts-zshaped fonts-zshaped-term
	FONT_S=( $(find dist -type d -name "[01][0-9].${PN}*") )
}
