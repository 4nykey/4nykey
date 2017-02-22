# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_SUFFIX=otf
S="${WORKDIR}"
inherit font-r1

DESCRIPTION="A typeface that mimics handwriting"
HOMEPAGE="http://pecita.eu"
SRC_URI=""
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS=""
IUSE="+binary"

DEPEND="
	net-misc/wget
	!binary? ( media-gfx/fontforge )
"

src_unpack() {
	local _u="${HOMEPAGE}/b/"
	wget --no-verbose ${_u}README.txt \
	$(usex binary "${_u}Pecita.otf" "${_u}PecitaSource.sfd ${_u}compile.pe")
}

src_compile() {
	use binary && return
	fontforge -script "${S}"/compile.pe || die
}
