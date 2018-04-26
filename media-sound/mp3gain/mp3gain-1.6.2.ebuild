# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3
EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/code"
EGIT_COMMIT="${PV}"
S="${WORKDIR}/${P}/${PN}"
inherit toolchain-funcs

DESCRIPTION="A program to analyze and adjust MP3 files to same volume"
HOMEPAGE="http://mp3gain.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	media-sound/mpg123
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	git-r3_fetch
	git-r3_checkout "${EGIT_REPO_URI}" '' '' ${PN}
	tc-export CC
}

src_install() {
	dobin mp3gain
}
