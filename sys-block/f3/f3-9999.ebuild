# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AltraMayor/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="64d169e"
	SRC_URI="
		mirror://githubcl/AltraMayor/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="F3 - Fight Flash Fraud"
HOMEPAGE="http://oss.digirati.com.br/f3"

LICENSE="GPL-3"
SLOT="0"
IUSE="extras"

DEPEND="
	extras? ( virtual/libudev sys-block/parted )
"
RDEPEND="${DEPEND}"
DOCS=( README.md changelog f3write.h2w log-f3wr )

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		all $(usex extras extra '')
}

src_install() {
	emake \
		PREFIX="${ED}/usr" \
		install $(usex extras install-extra '')
	einstalldocs
}
