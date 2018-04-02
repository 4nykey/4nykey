# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/code"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="mirror://sourceforge/${PN}/${P//./_}-src.zip"
	S="${WORKDIR}"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	PATCHES=( "${FILESDIR}"/${PN}-ctype.diff )
fi
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
	app-arch/unzip
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_fetch
		git-r3_checkout "${EGIT_REPO_URI}" '' '' ${PN}
	else
		default
	fi
}

src_prepare() {
	default
	sed -i \
		-e 's:CFLAGS= -Wall -O2:CFLAGS+= -Wall:' \
		-e 's:$(CC) -o:$(CC) $(LDFLAGS) -o:' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin mp3gain || die
}
