# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit unpacker gnome2

DESCRIPTION="cloud.mail.ru sync client"
HOMEPAGE="http://help.mail.ru/cloud_web/app/about"
SRC_URI="https://linuxdesktopcloud.mail.ru/deb/mail.ru-cloud_${PV}"
SRC_URI="
	amd64? (
		!ayatana? ( ${SRC_URI}_amd64.deb )
		ayatana? ( ${SRC_URI}-appind_amd64.deb )
	)
	x86? (
		!ayatana? ( ${SRC_URI}_i386.deb )
		ayatana? ( ${SRC_URI}-appind_i386.deb )
	)
"
RESTRICT="primaryuri"

LICENSE="EULA"
LICENSE_URL="https://cloud.mail.ru/LA/desktop"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana"

DEPEND="
	app-arch/unzip
"
RDEPEND="
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	net-dns/libidn
	x11-libs/libX11
	ayatana? ( dev-libs/libappindicator:2 )
"
S="${WORKDIR}/usr"

src_prepare() {
	default
	sed \
		-e 's:Internet:X-&:' \
		-e "s:Exec=cloud:Exec=${PN}:" \
		-i share/applications/mail.ru-cloud.desktop
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr
	doins -r share
	into /opt
	newbin bin/cloud ${PN}
}
