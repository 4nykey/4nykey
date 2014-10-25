# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="Estonian ID Card signing for Chrome"
HOMEPAGE="http://id.ee/"
SRC_URI="https://installer.id.ee/media/sources/${MY_CN}-${MY_CV}.tar.gz"
BASE_URI="https://installer.id.ee/media/ubuntu/pool/main"
SRC_URI="${BASE_URI}/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	dev-cpp/gtkmm:3.0
	sys-apps/pcsc-lite
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"
DEPEND="
	${DEPEND}
	app-arch/unzip
"
EXTID="knbfaekihfoeoceefceadfonbmgpfeok"

src_prepare() {
	mkdir -p "${EXTID}/${PV}_0"
	unzip -qq -o ${PN}.crx -d "${EXTID}/${PV}_0" 
}

src_compile() {
	emake \
		COPT="${CXXFLAGS}" \
		CCMD="$(tc-getCXX)" \
		all
}

src_install() {
	dobin out/chrome-token-signing
	insinto /usr/share/chrome-token-signing
	doins *.{json,xml}
	dodir /etc/chromium/{native-messaging-hosts,policies/managed}
	dosym /usr/share/chrome-token-signing/ee.ria.esteid.json \
		/etc/chromium/native-messaging-hosts/ee.ria.esteid.json
	dosym /usr/share/chrome-token-signing/esteid_policy.json \
		/etc/chromium/policies/managed/esteid_policy.json
	dodir /usr/$(get_libdir)/chromium-browser/extensions
	insinto /usr/$(get_libdir)/chromium-browser/extensions
	doins -r ${EXTID}
	local d
	for d in chrome{,-beta,-unstable}; do
		dosym /usr/$(get_libdir)/chromium-browser/extensions/${EXTID} \
			/opt/google/${d}/extensions/${EXTID} 
	done
}
