# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit unpacker fdo-mime gnome2-utils

DESCRIPTION="cloud.mail.ru sync client"
HOMEPAGE="http://help.mail.ru/cloud_web/app/about"
SRC_URI="
	amd64? (
		https://linuxdesktopcloud.mail.ru/deb/mail.ru-cloud_${PV}_amd64.deb
	)
	x86? (
		https://linuxdesktopcloud.mail.ru/deb/mail.ru-cloud_${PV}_i386.deb
	)
"
RESTRICT="primaryuri"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND="
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	net-dns/libidn
	x11-libs/libX11
"
S="${WORKDIR}/usr"

src_prepare() {
	sed \
		-e 's:Internet:X-&:' \
		-e "s:Exec=cloud:Exec=${PN}:" \
		-i share/applications/mail.ru-cloud.desktop
}

src_install() {
	insinto /usr
	doins -r share
	into /opt
	newbin bin/cloud ${PN}
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
