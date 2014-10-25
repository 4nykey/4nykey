# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils nsplugins

MY_PN="esteidfirefoxplugin"
MY_P="${MY_PN}-${PV}"
MY_LN="esteidpkcs11loader"
MY_LV="3.8.1.1056"
MY_CN="chrome-token-signing"
MY_CV="3.9.0.374"

DESCRIPTION="Estonian ID card browser plugin"
HOMEPAGE="http://id.ee/"
SRC_URI="
	https://installer.id.ee/media/sources/${MY_P}.tar.gz
	https://installer.id.ee/media/sources/${MY_LN}-${MY_LV}.tar.gz
	chromium? ( 
		https://installer.id.ee/media/sources/${MY_CN}-${MY_CV}.tar.gz
	)
"
BASE_URI="https://installer.id.ee/media/ubuntu/pool/main"
SRC_URI="
	${BASE_URI}/${MY_PN:0:1}/${MY_PN}/${MY_PN}_${PV}-ubuntu-13-10.tar.gz
	${BASE_URI}/${MY_LN:0:1}/${MY_LN}/${MY_LN}_${MY_LV}-ubuntu-13-10.tar.gz
	chromium? ( 
		${BASE_URI}/${MY_CN:0:1}/${MY_CN}/${MY_CN}_${MY_CV}-ubuntu-14-04.tar.gz
	)
"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chromium debug"

DEPEND="
	x11-libs/gtk+:2
	dev-libs/openssl
	chromium? (
		dev-cpp/gtkmm:3.0
		sys-apps/pcsc-lite
	)
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"

S="${WORKDIR}/${MY_LN}"

src_compile() {
	emake -C "${WORKDIR}/${MY_PN}" plugin
	cmake-utils_src_compile
	use chromium && emake -C "${WORKDIR}/${MY_CN}-${MY_CV}"
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins "${WORKDIR}"/${MY_PN}/npesteid-firefox-plugin.so
	cmake-utils_src_install
	if use chromium; then
		cd "${WORKDIR}/${MY_CN}-${MY_CV}"
		dobin out/chrome-token-signing
		insinto /usr/share/chrome-token-signing
		doins *.{crx,json,xml}
		dodir /etc/chromium/{native-messaging-hosts,policies/managed}
		dosym /usr/share/chrome-token-signing/ee.ria.esteid.json \
			/etc/chromium/native-messaging-hosts/ee.ria.esteid.json
		dosym /usr/share/chrome-token-signing/esteid_policy.json \
			/etc/chromium/policies/managed/esteid_policy.json
	fi
}
