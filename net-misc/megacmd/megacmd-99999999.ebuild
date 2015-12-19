# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit golang-build

EGO_PN="github.com/t3rm1n4l/${PN}"
inherit golang-build
if [[ -z ${PV%%*9999} ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	MY_MC="d7f3f3a"
	MY_GM="go-mega-551abb8"
	MY_GH="go-humanize-e7ed15b"
	SRC_URI="
	mirror://githubcl/${EGO_PN#*/}/tar.gz/${MY_MC}
	-> ${P}.tar.gz
	mirror://githubcl/t3rm1n4l/${MY_GM%-*}/tar.gz/${MY_GM##*-}
	-> ${MY_GM}.tar.gz
	mirror://githubcl/t3rm1n4l/${MY_GH%-*}/tar.gz/${MY_GH##*-}
	-> ${MY_GH}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="A command-line client for mega.nz storage service"
HOMEPAGE="https://github.com/t3rm1n4l/megacmd/"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		golang-vcs_src_unpack
		cp -r "${EGO_STORE_DIR}"/src/${EGO_PN%/*} "${S}"/src/${EGO_PN%%/*}/
	else
		golang-vcs-snapshot_src_unpack
		default
		mv ${MY_GM} "${S}/src/${EGO_PN%/*}"/${MY_GM%-*}
		mv ${MY_GH} "${S}/src/${EGO_PN%/*}"/${MY_GH%-*}
	fi
}

src_install() {
	dobin ${PN}
	dodoc src/${EGO_PN}/README.md
}
