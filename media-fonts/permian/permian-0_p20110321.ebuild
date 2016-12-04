# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf"
inherit font-r1 unpacker

DESCRIPTION="An universal font family for a wide range of tasks"
HOMEPAGE="http://www.artlebedev.ru/perm/${PN}"
SRC_URI="
	http://${PN}.design.ru/${PN}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(unpacker_src_uri_depends)"
S="${WORKDIR}"
