# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/certs.git"
else
	SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
	SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Estonian ID card certificates"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	!app-misc/sk-certificates
"

src_install() {
	insinto /usr/share/esteid/certs
	find "${S}" -type f -name '*.crt' -print0| xargs -0 doins
}
