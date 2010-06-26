# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

MY_PN="57xxLinuxSteelVineManager"
DESCRIPTION="Silicon Image SteelVine Manager for SiI57xx chips"
HOMEPAGE="http://www.siliconimage.com/support/searchresults.aspx?pid=105&cat=24"
SRC_URI="http://www.siliconimage.com/docs/${MY_PN}_V${PV//\./_}.tar.gz"
S="${WORKDIR}/${MY_PN/Linux}"
RESTRICT="primaryuri strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	x86? (
		media-libs/libpng:1.2
		media-libs/fontconfig
		x11-libs/libXcursor
		x11-libs/libXrandr
		x11-libs/libSM
		x11-libs/libXinerama
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libICE
		x11-libs/libXrender
	)
	amd64? (
		app-emulation/emul-linux-x86-xlibs
	)
"

pkg_setup() {
	enewuser steelvine -1 -1 /var/lib/${PN} disk
}

src_install() {
	local _ipth="/opt/${PN}"

	insinto ${_ipth}
	doins -r icons S* Translations
	fperms 0755 ${_ipth}/SteelVine{,Manager}

	insinto /etc/xdg
	newins "${FILESDIR}"/${PN}.cfg Trolltech.conf
	newinitd "${FILESDIR}"/${PN}.rc ${PN}

	make_wrapper ${PN} ${_ipth}/SteelVineManager
	newicon sv2000.xpm ${PN}.xpm
	make_desktop_entry ${PN} "SteelVine Manager"
}
