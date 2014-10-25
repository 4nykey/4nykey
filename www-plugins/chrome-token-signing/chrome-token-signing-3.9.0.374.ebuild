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
	unzip -qq -o ${PN}.crx -d extension 2>/dev/null
	[[ $? -le 1 ]] || die "failed to unpack ${PN}.crx"
}

src_compile() {
	emake \
		COPT="${CXXFLAGS}" \
		CCMD="$(tc-getCXX)" \
		all
}

src_install() {
	dobin out/${PN}
	insinto ${EROOT}usr/share/${PN}
	doins -r extension *.{json,xml}
	dodir ${EROOT}etc/chromium/{native-messaging-hosts,policies/managed}
	dosym ../../../usr/share/${PN}/ee.ria.esteid.json \
		${EROOT}etc/chromium/native-messaging-hosts/ee.ria.esteid.json
	dosym ../../../../usr/share/${PN}/esteid_policy.json \
		${EROOT}etc/chromium/policies/managed/esteid_policy.json
	dodir ${EROOT}usr/$(get_libdir)/chromium-browser/extensions/${EXTID}
	dosym ../../../../share/${PN}/extension \
		${EROOT}usr/$(get_libdir)/chromium-browser/extensions/${EXTID}/${PV}_0
}

pkg_postinst() {
	elog "To use this with www-client/google-chrome"
	elog "open chrome://extensions, enable developer mode"
	elog "press 'Load unpacked extension' and navigate to"
	elog "${EROOT}usr/share/${PN}/extension"
}
