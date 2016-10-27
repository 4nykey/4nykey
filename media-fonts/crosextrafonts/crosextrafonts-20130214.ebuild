# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

S="${WORKDIR}"
inherit font-r1

DESCRIPTION="ChromiumOS extra fonts"
HOMEPAGE="http://www.chromium.org/chromium-os"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/"
SRC_URI="
	${SRC_URI}${P}.tar.gz
	${SRC_URI}${PN}-carlito-20130920.tar.gz
"
RESTRICT="primaryuri"
EGIT_REPO_URI="https://code.google.com/p/noto"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S=( ${P} ${PN}-carlito-20130920 )
