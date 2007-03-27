# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Marin unicode true-type font"
HOMEPAGE="http://web.meson.org/write/fonts/mine/"
SRC_URI="http://web.meson.org/downloads/Marin.zip"
S="${WORKDIR}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_SUFFIX="ttf"
FONT_S="${S}"
