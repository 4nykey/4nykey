# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PATCHES=( "${FILESDIR}"/${PN}-desktop.diff )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
	PATCHES+=( "${FILESDIR}"/${PN}-binary.diff )
else
	inherit vcs-snapshot
	MY_PV="v${PV}-dev"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="Cutegram is a free and opensource telegram client"
HOMEPAGE="http://aseman.co/en/products/cutegram"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	net-libs/TelegramQML
	dev-qt/aseman-qt-tools[keychain,positioning]
	dev-qt/qtdbus:5
	dev-qt/qtprintsupport:5
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5 \
		CONFIG+=binaryMode
}

src_install() {
	emake INSTALL_ROOT="${ED}/usr" install
}
