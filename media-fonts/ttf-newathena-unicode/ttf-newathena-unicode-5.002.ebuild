# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="NAU"
MY_PV="${PV//./_}"
S="${WORKDIR}/${MY_PN}${PV}"

inherit unpacker font-r1

DESCRIPTION="New Athena Unicode is a freeware multilingual font"
HOMEPAGE="http://socrates.berkeley.edu/~pinax/greekkeys/NAUdownload.html"
SRC_URI="http://socrates.berkeley.edu/~pinax/greekkeys/fonts/${MY_PN}${MY_PV}.zip"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"

DOCS="AboutNAUfont_v${MY_PV}.pdf"
FONT_SUFFIX="ttf"
