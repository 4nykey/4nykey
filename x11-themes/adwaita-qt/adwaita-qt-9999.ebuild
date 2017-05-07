# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MartinBriza/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/MartinBriza/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A style to bend Qt applications to look like they belong into GNOME Shell"
HOMEPAGE="https://github.com/MartinBriza/adwaita-qt"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="qt4 qt5"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtdbus:4
	)
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtdbus:5
	)
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	if use qt4; then
		BUILD_DIR="${WORKDIR}/${PN}_qt4"
		local mycmakeargs=( -DUSE_QT4=ON )
		cmake-utils_src_configure
	fi
	if use qt5; then
		BUILD_DIR="${WORKDIR}/${PN}_qt5"
		local mycmakeargs=( -DUSE_QT4=OFF )
		cmake-utils_src_configure
	fi
}

src_compile() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake-utils_src_compile -C "${_d}"
	done
}

src_install() {
	local _d
	for _d in "${WORKDIR}"/${PN}_qt*; do
		cmake-utils_src_install -C "${_d}"
	done
}
