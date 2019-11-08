# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5915ea9"
	SRC_URI="
		mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_LSS="linux-syscall-support-8048ece"
SRC_URI+="
	mirror://githubcl/PaoJiao/${MY_LSS%-*}/tar.gz/${MY_LSS##*-}
	-> ${MY_LSS}.tar.gz
"
inherit autotools

DESCRIPTION="A crash-reporting system"
HOMEPAGE="https://chromium.googlesource.com/breakpad/breakpad"

LICENSE="BSD"
SLOT="0"

IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	unpack ${MY_LSS}.tar.gz
	mv ${MY_LSS} src/third_party/lss
	default
	eautoreconf
}
