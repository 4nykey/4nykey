# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

MY_PN="LinLibertineFont"
DESCRIPTION="A free TrueType Unicode font similar to Times New Roman"
HOMEPAGE="http://linuxlibertine.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN#ttf-}/${MY_PN}-${PV}.tgz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2 OFL"
SLOT="0"
KEYWORDS="~x86"
IUSE="opentype"

DOCS="Bugs ChangeLog.txt LICENCE.txt Readme"
FONT_SUFFIX="ttf"
use opentype && FONT_SUFFIX="${FONT_SUFFIX} otf"
FONT_S="${S}"
