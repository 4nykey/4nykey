# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs qmake-utils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	SRC_URI="https://installer.id.ee/media/sources/${MY_CN}-${MY_CV}.tar.gz"
	SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi


DESCRIPTION="Estonian ID Card signing for Chrome"
HOMEPAGE="http://id.ee/"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtwidgets:5
	dev-libs/openssl:0
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"

src_configure() {
	cd "${S}"/host-linux
	eqmake5
}

src_install() {
	dobin host-linux/${PN}
	insinto /usr/share/${PN}
	doins -r extension {.,host-linux}/*.json

	for d in '/chromium/' '/opt/chrome/'; do
		dodir /etc${d}{native-messaging-hosts,policies/managed}
		dosym /usr/share/${PN}/ee.ria.esteid.json \
			/etc${d}native-messaging-hosts/ee.ria.esteid.json
	done
}

pkg_postinst() {
	elog "To load the extension, open chrome://extensions,"
	elog "enable developer mode, press 'Load unpacked extension'"
	elog "and navigate to /usr/share/${PN}/extension"
}
