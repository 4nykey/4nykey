# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nidud/${PN}.git"
else
	MY_PV="22d6dc2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/nidud/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Asmc Macro Assembler"
HOMEPAGE="https://github.com/nidud/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e "s:\<gcc\>:$(tc-getCC) ${LDFLAGS}:" \
		-e 's: -s : :' \
		-i source/asmc/gcc/makefile
	chmod +x bin/asmc64
	default
}

src_compile() {
	emake \
		-C source/asmc/gcc \
		-f makefile \
		asmc64
	mv source/asmc/gcc/asmc64 bin
	emake \
		-C source/asmc/gcc \
		-f makefile \
		asmc64
}

src_install() {
	newbin source/asmc/gcc/asmc64 ${PN}
	einstalldocs
}
