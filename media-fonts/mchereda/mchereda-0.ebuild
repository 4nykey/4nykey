# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES=( otf +ttf )
S="${WORKDIR}"
inherit font-r1 unpacker

DESCRIPTION="Fonts by Michael Chereda: Bravo, Casper, Marta"
HOMEPAGE="https://www.behance.net/${PN}"
SRC_URI="
	https://dl.dropboxusercontent.com/u/57042481/Bravo%20Typeface.zip
	http://dl.dropbox.com/u/57042481/Marta%20Typeface.zip
	https://dl.dropboxusercontent.com/u/57042481/Casper%20Typface.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
