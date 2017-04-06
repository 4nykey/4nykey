# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MartinBriza/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="36e03a0"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/MartinBriza/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="A Qt Platform Theme aimed to accommodate GNOME settings"
HOMEPAGE="https://github.com/MartinBriza/QGnomePlatform"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtwidgets:5
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
