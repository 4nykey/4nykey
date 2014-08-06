# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base qmake-utils git-r3

DESCRIPTION="A QT5 Telegram client"
HOMEPAGE="http://labs.sialan.org/projects/sigram"
EGIT_REPO_URI="https://github.com/sialan-labs/sigram.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana"

RDEPEND="
	dev-qt/qtmultimedia:5
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtsvg:5
	dev-qt/qtsql:5[sqlite]
	ayatana? ( dev-libs/libappindicator:2 )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
RDEPEND="
	${RDEPEND}
	media-fonts/droid
	media-fonts/opensans
"


src_prepare() {
	if use ayatana; then
		sed -e 's:^#\(SUBDIRS\):\1:' -i libs/libs.pro
		printf 'CONFIG += link_pkgconfig\nPKGCONFIG = appindicator-0.1\n' >>\
			libs/UnitySystemTray/UnitySystemTray.pro
	fi
}

src_configure() {
	eqmake5 $(qmake-utils_find_pro_file)
}

src_install() {
	local instdir="/usr/$(get_libdir)/${PN}"

	exeinto ${instdir}
	doexe build/Sigram

	insinto ${instdir}
	doins build/*.pub
	find build -mindepth 1 -maxdepth 1 -type d -! -name fonts | xargs doins -r

	einstalldocs
	newicon build/icons/icon.png ${PN}.png
	make_wrapper ${PN} ${instdir}/Sigram ${instdir}
	make_desktop_entry ${PN} "Sigram" ${PN}
}
