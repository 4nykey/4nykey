# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf"
inherit font-r1 unpacker

DESCRIPTION="An unicode serif font meant for body text"
HOMEPAGE="http://pjmiller.deviantart.com/art/Kelvinch-Release-Version-600800030"
SRC_URI="
	http://orig06.deviantart.net/605e/f/2016/267/d/d/${PN}_release_version_by_pjmiller-d9xp89q.zip
	-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(unpacker_src_uri_depends)"
S="${WORKDIR}/Release Version"
DOCS=( "Kelvinch Fontlog.txt" )
