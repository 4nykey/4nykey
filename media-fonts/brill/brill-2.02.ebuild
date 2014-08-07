# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit font

DESCRIPTION="A typeface with the complete coverage of the Latin, Greek and Cyrillic script"
HOMEPAGE="http://www.brill.com/about/brill-fonts"
SRC_URI="
	${PN}_font_package_${PV/./_}.zip
	${PN}_roman_italic_and_bold_italic_font-ttf_0.zip
"
RESTRICT="primaryuri fetch"

LICENSE="BRILL-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="otf ttf"
DOCS="Brill_Typeface_User_Guide_${PV}.pdf"

pkg_nofetch() {
	local f
	einfo "Please accept the license at"
	einfo "http://www.brill.com/about/brill-typeface/brill-fonts-end-user-license-agreement"
	einfo "download the following files:"
	for f in ${A}; do einfo " '${f}'"; done
	einfo "and move them to '${DISTDIR}'"
}

src_prepare() {
	mv Brill_Typeface_${PV}/*.otf .
}
