# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}/Brill_Typeface_${PV}"
inherit font unpacker

DESCRIPTION="A typeface with the complete coverage of the Latin, Greek and Cyrillic script"
HOMEPAGE="http://www.brill.com/about/brill-fonts"
SRC_URI="
	${PN}_font_package_${PV/./_}.zip
"
RESTRICT="primaryuri fetch"

LICENSE="BRILL-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	$(unpacker_src_uri_depends)
"

FONT_SUFFIX="ttf"
DOCS="Brill_Typeface_User_Guide_${PV}.pdf"

pkg_nofetch() {
	einfo "Please accept the license at"
	einfo "http://www.brill.com/about/brill-typeface/brill-fonts-end-user-license-agreement"
	einfo "download ${A} and move it to '${DISTDIR}'"
}

src_prepare() {
	mv Brill_Typeface_${PV}/*.otf .
}
