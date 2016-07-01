# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

MY_PN="certs"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5415bae"
	SRC_URI="
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Estonian ID card certificates"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/esteid/certs
	doins *.crt
}
