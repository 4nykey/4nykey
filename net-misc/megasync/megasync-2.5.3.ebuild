# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit unpacker fdo-mime gnome2-utils

DESCRIPTION="mega.nz sync client"
HOMEPAGE="https://mega.nz"
SRC_URI="
	amd64? ( https://mega.nz/linux/MEGAsync/Debian_8.0/amd64/${PN}_${PV}_amd64.deb )
	x86? ( https://mega.nz/linux/MEGAsync/Debian_8.0/i386/${PN}_${PV}_i386.deb )
"
RESTRICT="strip primaryuri"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND="
	dev-db/sqlite:3
	net-dns/c-ares
	dev-libs/openssl:0
	dev-qt/qtgui:4
"
S="${WORKDIR}/usr"

src_prepare() {
	mv ${S}/share/doc/{${PN},${PF}}
}

src_install() {
	insinto /usr
	doins -r share
	into /opt
	dobin bin/${PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
