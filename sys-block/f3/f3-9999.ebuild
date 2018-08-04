# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AltraMayor/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="7402810"
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
IUSE="doc extras"

RDEPEND="
	extras? ( virtual/libudev sys-block/parted )
"
DEPEND="
	${RDEPEND}
	doc? ( dev-python/sphinx )
"
src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		all $(usex extras extra '')
	use doc && emake -C doc html
}

src_install() {
	local DOCS=(
		README.rst changelog f3write.h2w log-f3wr
		doc/{contribute,history,usage}.rst
		$(usex doc doc/_build/html '')
	)

	emake \
		PREFIX="${ED}/usr" \
		install $(usex extras install-extra '')
	einstalldocs
}
