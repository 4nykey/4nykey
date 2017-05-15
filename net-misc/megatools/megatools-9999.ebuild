# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/megous/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/megous/${PN}/tar.gz/${PV//_/-} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Command line tools and C library for accessing Mega cloud storage"
HOMEPAGE="http://megatools.megous.com"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/glib:2
	dev-libs/openssl:0
	net-misc/curl
"
RDEPEND="
	${DEPEND}
	net-libs/glib-networking[ssl]
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
	app-text/asciidoc
"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake V=0
}
