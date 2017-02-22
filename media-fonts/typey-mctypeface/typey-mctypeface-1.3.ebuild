# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_SUFFIX=otf
inherit font-r1 unpacker

DESCRIPTION="A modern serif typeface"
HOMEPAGE="http://pjmiller.deviantart.com/art/Typey-McTypeface-630507226"
SRC_URI="
	http://orig09.deviantart.net/678e/f/2016/257/5/8/${PN/-/_}_by_pjmiller-dafdyhm.zip
	-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(unpacker_src_uri_depends)"
S="${WORKDIR}/Typey McTypeface"
DOCS=( "Typey Fontlog.txt" )
