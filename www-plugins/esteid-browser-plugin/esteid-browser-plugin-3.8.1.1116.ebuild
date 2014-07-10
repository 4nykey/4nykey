# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils nsplugins

MY_PN="esteidfirefoxplugin"
MY_P="${MY_PN}-${PV}"
MY_EXT="esteidpkcs11loader"

DESCRIPTION="Estonian ID card digital signing browser plugin"
HOMEPAGE="http://installer.id.ee/"
SRC_URI="
	https://installer.id.ee/media/sources/${MY_P}.tar.gz
	https://installer.id.ee/media/sources/${MY_EXT}.tar.gz
"
BASE_URI="https://installer.id.ee/media/ubuntu/pool/main/${MY_PN:0:1}"
SRC_URI="
	${BASE_URI}/${MY_PN}/${MY_PN}_${PV}-ubuntu-13-10.tar.gz
	${BASE_URI}/${MY_EXT}/${MY_EXT}_${PV%.*}.1056-ubuntu-13-10.tar.gz
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
	app-misc/sk-certificates
	dev-libs/opensc
"

S="${WORKDIR}/${MY_EXT}"

src_compile() {
	emake -C "${WORKDIR}"/${MY_PN} plugin
	cmake-utils_src_compile
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins "${WORKDIR}"/${MY_PN}/npesteid-firefox-plugin.so
	cmake-utils_src_install
}
