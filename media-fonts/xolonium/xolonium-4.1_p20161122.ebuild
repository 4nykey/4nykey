# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( otf +ttf )
S="${WORKDIR}/${PN}-fonts-${PV%_*}"
inherit font-r1

DESCRIPTION="A futuristic font with focus on legibility"
HOMEPAGE="https://fontlibrary.org/en/font/${PN}"
SRC_URI="e00c124f3e1b130e5ec2a7eee2f4f1b8"
SRC_URI="mirror://fontlibrary/${PN}/${SRC_URI}/${PN}.zip -> ${P}.zip"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
FONT_S=( otf ttf )
