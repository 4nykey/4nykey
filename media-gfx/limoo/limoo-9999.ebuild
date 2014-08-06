# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base qmake-utils git-r3

DESCRIPTION="Limoo is multiplatform and modern image viewer"
HOMEPAGE="https://github.com/sialan-labs/limoo"
EGIT_REPO_URI="https://github.com/sialan-labs/limoo.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtwidgets:5
	dev-qt/qtscript:5
	media-gfx/exiv2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local project_file=$(qmake-utils_find_pro_file)
	eqmake5 "${project_file}"
}

src_install() {
	local instdir="/usr/$(get_libdir)/${PN}"

	exeinto ${instdir}/bin
	doexe Limoo

	insinto ${instdir}
	doins -r qml

	einstalldocs
	newicon installer/icon.png ${PN}.png
	make_wrapper ${PN} ${instdir}/bin/Limoo ${instdir}
	make_desktop_entry ${PN} "Limoo" ${PN}
}
