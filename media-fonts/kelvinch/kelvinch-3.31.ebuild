# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_SUFFIX=otf
inherit font-r1

DESCRIPTION="An unicode serif font meant for body text"
HOMEPAGE="http://pjmiller.deviantart.com/art/Kelvinch-Release-Version-600800030"
SRC_URI="
	http://orig07.deviantart.net/b190/f/2017/010/5/1/${PN}_release_version_by_pjmiller-d9xp89q.zip
	-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
S="${WORKDIR}/Release Version"
DOCS=( "Kelvinch Fontlog.txt" )
