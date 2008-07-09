# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Chrysanthi and Roman unicode TrueType fonts"
HOMEPAGE="http://everywitchway.net/linguistics/fonts"
SRC_URI="${HOMEPAGE}/chrysuni.zip ${HOMEPAGE}/roman.zip"
S="${WORKDIR}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

FONT_SUFFIX="ttf"
FONT_S="${S}"

src_install() {
	font_src_install
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins *.pdf
	fi
}
