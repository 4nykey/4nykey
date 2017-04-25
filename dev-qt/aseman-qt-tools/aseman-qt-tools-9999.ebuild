# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="fb538c7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="Set of tools for cross platforms Qt projects"
HOMEPAGE="https://github.com/Aseman-Land/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus keychain multimedia positioning sensors webengine webkit widgets"

DEPEND="
	dev-qt/qtdeclarative:5
	widgets? ( dev-qt/qtwidgets:5 )
	keychain? ( dev-libs/qtkeychain[qt5] )
	multimedia? ( dev-qt/qtmultimedia:5[qml] )
	sensors? ( dev-qt/qtsensors:5[qml] )
	webkit? ( dev-qt/qtwebkit:5[qml] )
	webengine? ( dev-qt/qtwebengine:5 )
	positioning? ( dev-qt/qtpositioning:5[qml] )
	dbus? ( dev-qt/qtdbus:5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	mkdir build
	cd build
	eqmake5 \
		DEFINES+="$(usex keychain '' DISABLE_KEYCHAIN)" \
		"${S}"
}

src_compile() {
	emake -C "${S}"/build
}

src_install() {
	emake INSTALL_ROOT="${D}" -C "${S}"/build install
	einstalldocs
}
