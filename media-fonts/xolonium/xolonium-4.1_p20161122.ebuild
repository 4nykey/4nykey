# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
S="${WORKDIR}/${PN}-fonts-${PV%_*}"
inherit font-r1 unpacker

DESCRIPTION="A futuristic font with focus on legibility"
HOMEPAGE="http://openfontlibrary.org/en/font/xolonium"
SRC_URI="e00c124f3e1b130e5ec2a7eee2f4f1b8"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/${SRC_URI}/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(unpacker_src_uri_depends)
"
FONT_S=( otf ttf )
