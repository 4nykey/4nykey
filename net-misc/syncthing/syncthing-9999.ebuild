# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGO_PN="github.com/${PN}/${PN}"
S="${WORKDIR}/${P}/src/${EGO_PN}"
if [[ -z ${PV%%*9999} ]]; then
	#inherit golang-vcs
	inherit golang-base git-r3
	EGIT_CHECKOUT_DIR="${S}"
	EGIT_REPO_URI="https://${EGO_PN}"
else
	inherit golang-vcs-snapshot
	SRC_URI="mirror://githubcl/${PN}/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net/"

LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	[[ -n ${PV%%*9999} ]] && echo "v${PV}" > RELEASE
}

src_compile() {
	go run build.go -no-upgrade
}

src_install() {
	dobin bin/*
	doman man/*.[0-9]
	dodoc AUTHORS *.md
}
