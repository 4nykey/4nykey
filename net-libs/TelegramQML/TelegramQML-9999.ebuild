# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="df762d7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="Telegram API tools for QtQml"
HOMEPAGE="https://github.com/Aseman-Land/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	net-libs/libqtelegram-aseman-edition
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtsql:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
