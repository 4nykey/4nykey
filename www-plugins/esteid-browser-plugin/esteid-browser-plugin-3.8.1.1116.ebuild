# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils nsplugins

MY_PN="esteidfirefoxplugin"
MY_P="${MY_PN}-${PV}"
MY_LN="esteidpkcs11loader"
MY_LV="3.8.1.1056"

DESCRIPTION="Estonian ID card browser plugin"
HOMEPAGE="http://id.ee/"
SRC_URI="
	https://installer.id.ee/media/sources/${MY_P}.tar.gz
	https://installer.id.ee/media/sources/${MY_LN}-${MY_LV}.tar.gz
"
BASE_URI="https://installer.id.ee/media/ubuntu/pool/main"
SRC_URI="
	${BASE_URI}/${MY_PN:0:1}/${MY_PN}/${MY_PN}_${PV}-ubuntu-13-10.tar.gz
	${BASE_URI}/${MY_LN:0:1}/${MY_LN}/${MY_LN}_${MY_LV}-ubuntu-13-10.tar.gz
"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	x11-libs/gtk+:2
	dev-libs/openssl
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"

S="${WORKDIR}/${MY_LN}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CFLAGS}" \
		-C "${WORKDIR}/${MY_PN}" plugin
	cmake-utils_src_compile
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins "${WORKDIR}"/${MY_PN}/npesteid-firefox-plugin.so
	cmake-utils_src_install
}
