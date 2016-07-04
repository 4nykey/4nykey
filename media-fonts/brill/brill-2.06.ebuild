# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

S="${WORKDIR}/Brill_Typeface_${PV}"
inherit font unpacker

DESCRIPTION="A typeface with the complete coverage of the Latin, Greek and Cyrillic script"
HOMEPAGE="http://www.brill.com/about/brill-fonts"
SRC_URI="
	http://www.brill.com/sites/default/files/${PN}_font_package_${PV/./_}.zip
"
RESTRICT="primaryuri"

LICENSE="EULA"
LICENSE_URL="http://www.brill.com/about/brill-typeface/brill-fonts-end-user-license-agreement"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	$(unpacker_src_uri_depends)
"

FONT_SUFFIX="ttf"
DOCS="Brill_Typeface_User_Guide_${PV}.pdf"

src_prepare() {
	default
	local f
	for f in *.ttf; do mv -f "${f}" "${f// /}"; done
}
