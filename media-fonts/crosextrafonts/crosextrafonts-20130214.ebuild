# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}"
inherit font-r1

DESCRIPTION="ChromiumOS extra fonts"
HOMEPAGE="https://www.chromium.org/chromium-os"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/"
SRC_URI="
	${SRC_URI}${P}.tar.gz
	${SRC_URI}${PN}-carlito-20130920.tar.gz
"
RESTRICT="primaryuri"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_S=( ${P} ${PN}-carlito-20130920 )
