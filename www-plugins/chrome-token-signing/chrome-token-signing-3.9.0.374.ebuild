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

src_compile() {
	emake \
		COPT="${CXXFLAGS}" \
		CCMD="$(tc-getCXX)" \
		all
}

src_install() {
	local _eid="knbfaekihfoeoceefceadfonbmgpfeok" _pth="${EROOT}usr/share/${PN}" d
	dobin out/${PN}
	insinto ${_pth}
	doins *.{crx,json,xml}

	for d in '/chromium/' '/opt/chrome/'; do
		dodir ${EROOT}etc${d}{native-messaging-hosts,policies/managed}
		dosym ${EROOT}usr/share/${PN}/ee.ria.esteid.json \
			${EROOT}etc${d}native-messaging-hosts/ee.ria.esteid.json
		dosym ${EROOT}usr/share/${PN}/esteid_policy.json \
			${EROOT}etc${d}policies/managed/esteid_policy.json
	done
	cat >"${T}"/${_eid}.json <<-EOF
	{
		"external_crx": "${_pth}/${PN}.crx",
		"external_version": "${PV}"
	}
	EOF
	insinto ${EROOT}usr/$(get_libdir)/chromium-browser/extensions
	doins "${T}"/${_eid}.json
	insinto ${EROOT}usr/share/google-chrome/extensions
	doins "${T}"/${_eid}.json
}
