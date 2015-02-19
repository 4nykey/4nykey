# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Fonts by artmaker"
HOMEPAGE="http://be.net/artmaker"
BASE_URI="http://openfontlibrary.org/assets/downloads/"
SRC_URI="
${BASE_URI}banana-brick/2100182bf265504c3dc286eccb6383a9/banana-brick.zip -> ${PN}-banana-brick-2011-12-19.zip
${BASE_URI}unique/1539764ecc445a7321c68badd777ccaa/unique.zip -> ${PN}-unique-2013-09-03.zip
${BASE_URI}vds/4af6691b4cf3d06bb623421ad4e10665/vds.zip -> ${PN}-vds-2012-10-05.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND=""
FONT_SUFFIX="otf ttf"
