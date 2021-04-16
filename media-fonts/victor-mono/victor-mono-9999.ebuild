# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( OTF TTF )
HELPER_ARGS=( mutatormath )
FONT_SRCDIR=.
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
inherit fontmake

DESCRIPTION="A free programming font with cursive italics and ligatures"
HOMEPAGE="https://rubjo.github.io/victor-mono"

LICENSE="MIT"
SLOT="0"
IUSE=""
BDEPEND="
	binary? ( app-arch/unzip )
"

src_prepare() {
	use binary && unpack public/VictorMonoAll.zip
	fontmake_src_prepare
}
