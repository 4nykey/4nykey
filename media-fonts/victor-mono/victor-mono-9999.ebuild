# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
FONT_S=( OTF TTF )
inherit font-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rubjo/${PN}.git"
else
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="09af47c"
	SRC_URI="
		mirror://githubcl/rubjo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A free programming font with cursive italics and ligatures"
HOMEPAGE="https://rubjo.github.io/victor-mono"

LICENSE="MIT"
SLOT="0"
IUSE=""
BDEPEND="
	app-arch/unzip
"

src_prepare() {
	unpack public/VictorMonoAll.zip
	default
}
