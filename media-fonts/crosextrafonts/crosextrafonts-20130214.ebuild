# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

DESCRIPTION="ChromiumOS extra fonts"
HOMEPAGE="http://www.chromium.org/chromium-os"
BASE_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/"
SRC_URI="
	${BASE_URI}${P}.tar.gz
	${BASE_URI}${PN}-carlito-20130920.tar.gz
"
RESTRICT="primaryuri"
EGIT_REPO_URI="https://code.google.com/p/noto"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="ttf"

src_prepare() {
	mv ../${PN}-carlito-20130920/*.ttf .
}
