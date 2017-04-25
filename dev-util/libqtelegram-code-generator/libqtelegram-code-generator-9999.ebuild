# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="3ac62ce"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="Generate API part of libqtelegram automatically"
HOMEPAGE="https://github.com/Aseman-Land/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	eqmake5
}

src_install() {
	dobin libqtelegram-generator
	einstalldocs
}
