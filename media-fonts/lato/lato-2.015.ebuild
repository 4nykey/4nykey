# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="ttf"
LICENSE="OFL-1.1"
MY_PN="${PN^}${PV%.*}${LICENSE%-*}"
inherit font-r1 unpacker

DESCRIPTION="A sanserif typeface family with classical proportions"
HOMEPAGE="http://www.latofonts.com"
SRC_URI="
	http://www.latofonts.com/download/${MY_PN}.zip
	-> ${P}.zip
"
RESTRICT="primaryuri"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(unpacker_src_uri_depends)"
S="${WORKDIR}/${MY_PN}"
