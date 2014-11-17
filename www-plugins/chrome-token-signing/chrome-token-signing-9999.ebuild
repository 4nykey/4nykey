# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit toolchain-funcs
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	SRC_URI="https://installer.id.ee/media/sources/${MY_CN}-${MY_CV}.tar.gz"
	SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
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
	dev-cpp/gtkmm:3.0
	dev-libs/openssl:0
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"

src_prepare() {
if [[ ${PV} = *9999* ]]; then
	mv ${PN} extension
else
	unzip -qq -o ${PN}.crx -d extension 2>/dev/null
	[[ $? -le 1 ]] || die "failed to unpack ${PN}.crx"
fi

}

src_compile() {
	emake \
		COPT="${CXXFLAGS}" \
		CCMD="$(tc-getCXX)" \
		all
}

src_install() {
	dobin out/${PN}
	insinto /usr/share/${PN}
	doins -r extension *.{json,xml}

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
