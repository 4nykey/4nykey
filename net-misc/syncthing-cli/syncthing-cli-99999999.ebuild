# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/${PN%-*}/${PN}"
inherit golang-build
if [[ -z ${PV%%*9999} ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	MY_PV="9594d39"
	SRC_URI="mirror://githubcl/${PN%-*}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="The Syncthing command line interface"
HOMEPAGE="https://syncthing.net/"

LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	net-misc/syncthing
"

src_prepare() {
	cp -r src/${EGO_PN}/Godeps/_workspace/src .
}

src_install() {
	dobin ${PN}
	dodoc src/${EGO_PN}/README.md
}
