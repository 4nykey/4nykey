# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Fonts by artmaker"
HOMEPAGE="http://be.net/artmaker"
SRC_URI="mirror://fontlibrary/"
SRC_URI="
	${SRC_URI}banana-brick/2100182bf265504c3dc286eccb6383a9/banana-brick.zip
	-> ${PN}-banana-brick-2011-12-19.zip
	${SRC_URI}unique/1539764ecc445a7321c68badd777ccaa/unique.zip
	-> ${PN}-unique-2013-09-03.zip
	${SRC_URI}vds/4af6691b4cf3d06bb623421ad4e10665/vds.zip
	-> ${PN}-vds-2012-10-05.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	font_pkg_setup
}
