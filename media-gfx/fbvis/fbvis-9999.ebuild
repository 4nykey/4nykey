# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs
EGIT_REPO_URI="http://repo.or.cz/${PN}.git"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="58caabc"
	SRC_URI="
		${EGIT_REPO_URI}/snapshot/${MY_PV}.tar.gz -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A framebuffer image viewer"
HOMEPAGE="http://repo.or.cz/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

src_prepare() {
	sed -e 's:FLAGS =:FLAGS +=:' -i Makefile
	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc README
}
